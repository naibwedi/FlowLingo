package com.flowlingo

import android.content.Context
import android.inputmethodservice.InputMethodService
import android.os.SystemClock
import android.view.HapticFeedbackConstants
import android.view.MotionEvent
import android.view.SoundEffectConstants
import android.view.View
import android.view.ViewGroup
import android.view.inputmethod.EditorInfo
import android.view.inputmethod.InputConnection
import android.widget.Button
import android.widget.ImageButton
import android.widget.TextView
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

class AppImeService : InputMethodService() {
    private val serviceScope = CoroutineScope(SupervisorJob() + Dispatchers.Main.immediate)

    private lateinit var translationChannel: TranslationChannel
    private lateinit var suggestionTextView: TextView
    private lateinit var pairIndicatorTextView: TextView
    private lateinit var statusTextView: TextView
    private lateinit var applyButton: ImageButton
    private lateinit var shiftButton: Button
    private lateinit var symbolsButton: Button
    private lateinit var enterButton: ImageButton
    private lateinit var characterButtons: List<Button>
    private lateinit var feedbackAnchorView: View

    private var currentBuffer = StringBuilder()
    private var translatedCandidate: String? = null
    private var debounceJob: Job? = null
    private var backspaceRepeatJob: Job? = null
    private var shiftState = ShiftState.OFF
    private var isSymbolsMode = false
    private var targetLanguage = "am"
    private var isHapticFeedbackEnabled = true
    private var isSoundFeedbackEnabled = false
    private var lastShiftTapAt = 0L

    override fun onCreate() {
        super.onCreate()
        translationChannel = TranslationChannel(AppEngineHolder.getOrCreate(application))
    }

    override fun onCreateInputView(): View {
        val view = layoutInflater.inflate(R.layout.keyboard_view, null)
        feedbackAnchorView = view
        suggestionTextView = view.findViewById(R.id.translationSuggestion)
        pairIndicatorTextView = view.findViewById(R.id.activeLanguagePair)
        statusTextView = view.findViewById(R.id.previewStatus)
        applyButton = view.findViewById<ImageButton>(R.id.applyTranslationButton)
        shiftButton = view.findViewById(R.id.keyShift)
        symbolsButton = view.findViewById(R.id.keySymbols)
        enterButton = view.findViewById<ImageButton>(R.id.keyEnter)
        characterButtons = collectCharacterButtons(view)

        bindCharacterKeys()
        bindSpecialKeys(view)
        refreshNativeSettings()
        renderIdleState()
        refreshKeyboardState()

        return view
    }

    override fun onStartInputView(info: EditorInfo?, restarting: Boolean) {
        super.onStartInputView(info, restarting)
        refreshNativeSettings()
        resetSessionState()
        updateEnterKeyIcon(info)
    }

    override fun onFinishInputView(finishingInput: Boolean) {
        debounceJob?.cancel()
        backspaceRepeatJob?.cancel()
        super.onFinishInputView(finishingInput)
    }

    override fun onDestroy() {
        serviceScope.cancel()
        super.onDestroy()
    }

    private fun bindCharacterKeys() {
        characterButtons.forEach { button ->
            button.setOnClickListener {
                val spec = button.tag as? String ?: return@setOnClickListener
                performKeyFeedback(FeedbackType.STANDARD)
                commitCharacter(resolveKeyValue(spec))
            }
            button.setOnLongClickListener {
                val spec = button.tag as? String ?: return@setOnLongClickListener false
                val alternateValue = resolveAlternateKeyValue(spec) ?: return@setOnLongClickListener false
                performKeyFeedback(FeedbackType.STANDARD)
                commitCharacter(alternateValue)
                true
            }
        }
    }

    private fun bindSpecialKeys(root: View) {
        shiftButton.setOnClickListener {
            performKeyFeedback(FeedbackType.STANDARD)
            advanceShiftState()
        }

        symbolsButton.setOnClickListener {
            performKeyFeedback(FeedbackType.STANDARD)
            isSymbolsMode = !isSymbolsMode
            shiftState = ShiftState.OFF
            refreshKeyboardState()
        }

        applyButton.setOnClickListener {
            performKeyFeedback(FeedbackType.RETURN)
            applyTranslation()
        }
        enterButton.setOnClickListener {
            performKeyFeedback(FeedbackType.RETURN)
            handleEnter()
        }

        root.findViewById<Button>(R.id.keySpace).setOnClickListener {
            performKeyFeedback(FeedbackType.SPACE)
            commitCharacter(" ")
        }

        root.findViewById<Button>(R.id.keyBackspace).setOnTouchListener { _, event ->
            when (event.actionMasked) {
                MotionEvent.ACTION_DOWN -> {
                    performKeyFeedback(FeedbackType.DELETE)
                    handleBackspace()
                    startBackspaceRepeat()
                    true
                }

                MotionEvent.ACTION_UP,
                MotionEvent.ACTION_CANCEL -> {
                    stopBackspaceRepeat()
                    true
                }

                else -> false
            }
        }
    }

    private fun commitCharacter(value: String) {
        val inputConnection = currentInputConnection ?: return
        inputConnection.commitText(value, 1)
        currentBuffer.append(value)
        translatedCandidate = null
        renderPendingState()
        scheduleTranslation()

        if (shiftState == ShiftState.ONCE && !isSymbolsMode && value.any { it.isLetter() }) {
            shiftState = ShiftState.OFF
            refreshKeyboardState()
        }
    }

    private fun handleBackspace() {
        val inputConnection = currentInputConnection ?: return
        if (currentBuffer.isNotEmpty()) {
            currentBuffer.deleteAt(currentBuffer.length - 1)
        }
        inputConnection.deleteSurroundingText(1, 0)

        translatedCandidate = null
        if (currentBuffer.isEmpty()) {
            debounceJob?.cancel()
            renderIdleState()
        } else {
            renderPendingState()
            scheduleTranslation()
        }
    }

    private fun handleEnter() {
        val editorInfo = currentInputEditorInfo
        val inputConnection = currentInputConnection ?: return
        val action = editorInfo?.imeOptions?.and(EditorInfo.IME_MASK_ACTION)

        when (action) {
            EditorInfo.IME_ACTION_GO,
            EditorInfo.IME_ACTION_SEARCH,
            EditorInfo.IME_ACTION_SEND,
            EditorInfo.IME_ACTION_NEXT,
            EditorInfo.IME_ACTION_DONE -> inputConnection.performEditorAction(action)
            else -> commitCharacter("\n")
        }
    }

    private fun scheduleTranslation() {
        debounceJob?.cancel()
        val source = currentBuffer.toString()
        if (source.isBlank()) {
            renderIdleState()
            return
        }

        debounceJob = serviceScope.launch {
            delay(400)
            val response = translationChannel.translate(source, targetLanguage)
            if (source != currentBuffer.toString()) {
                return@launch
            }

            if (response.isSuccess && !response.translatedText.isNullOrBlank()) {
                translatedCandidate = response.translatedText
                updatePreviewStatus(getString(
                    R.string.preview_status_ready,
                    response.targetLang.uppercase(),
                ))
                updatePreviewText(getString(
                    R.string.translation_ready,
                    response.targetLang.uppercase(),
                    response.translatedText,
                ))
                applyButton.isEnabled = true
            } else {
                translatedCandidate = null
                updatePreviewStatus(getString(R.string.preview_status_error))
                updatePreviewText(getString(R.string.translation_error))
                applyButton.isEnabled = false
            }
        }
    }

    private fun applyTranslation() {
        val translation = translatedCandidate ?: return
        val inputConnection = currentInputConnection ?: return
        replaceBufferedText(inputConnection, translation)
        currentBuffer = StringBuilder(translation)
        updatePreviewStatus(getString(
            R.string.preview_status_ready,
            targetLanguage.uppercase(),
        ))
        updatePreviewText(getString(
            R.string.translation_ready,
            targetLanguage.uppercase(),
            translation,
        ))
        applyButton.isEnabled = true
    }

    private fun replaceBufferedText(inputConnection: InputConnection, replacement: String) {
        if (currentBuffer.isNotEmpty()) {
            inputConnection.deleteSurroundingText(currentBuffer.length, 0)
        }
        inputConnection.commitText(replacement, 1)
    }

    private fun refreshKeyboardState() {
        characterButtons.forEach { button ->
            val spec = button.tag as? String ?: return@forEach
            button.text = resolveKeyLabel(spec)
        }

        shiftButton.isSelected = shiftState == ShiftState.ONCE
        shiftButton.isActivated = shiftState == ShiftState.CAPS_LOCK
        shiftButton.text = when (shiftState) {
            ShiftState.OFF -> getString(R.string.key_shift)
            ShiftState.ONCE -> getString(R.string.key_shift_on)
            ShiftState.CAPS_LOCK -> getString(R.string.key_caps_lock)
        }

        symbolsButton.isSelected = isSymbolsMode
        symbolsButton.isActivated = false
        symbolsButton.text = if (isSymbolsMode) {
            getString(R.string.key_letters)
        } else {
            getString(R.string.key_symbols)
        }
    }

    private fun resetSessionState() {
        currentBuffer = StringBuilder()
        translatedCandidate = null
        debounceJob?.cancel()
        backspaceRepeatJob?.cancel()
        shiftState = ShiftState.OFF
        isSymbolsMode = false
        renderIdleState()
        refreshKeyboardState()
    }

    private fun renderIdleState() {
        updatePreviewStatus(getString(R.string.preview_status_idle))
        updatePreviewText(getString(R.string.translation_idle))
        applyButton.isEnabled = false
    }

    private fun renderPendingState() {
        updatePreviewStatus(getString(
            R.string.preview_status_pending,
            targetLanguage.uppercase(),
        ))
        updatePreviewText(getString(R.string.translation_pending, targetLanguage.uppercase()))
        applyButton.isEnabled = false
    }

    private fun updateEnterKeyIcon(info: EditorInfo?) {
        val (iconRes, descriptionRes) = when (info?.imeOptions?.and(EditorInfo.IME_MASK_ACTION)) {
            EditorInfo.IME_ACTION_SEARCH -> R.drawable.ic_keyboard_search to R.string.key_search_description
            EditorInfo.IME_ACTION_SEND -> R.drawable.ic_keyboard_send to R.string.key_send_description
            EditorInfo.IME_ACTION_GO,
            EditorInfo.IME_ACTION_NEXT,
            EditorInfo.IME_ACTION_DONE -> R.drawable.ic_keyboard_action to R.string.key_action_description
            else -> R.drawable.ic_keyboard_enter to R.string.key_enter_description
        }

        enterButton.setImageResource(iconRes)
        enterButton.contentDescription = getString(descriptionRes)
    }

    private fun resolveKeyLabel(spec: String): String {
        val values = spec.split('|')
        val letter = values.getOrElse(0) { "" }
        val primarySymbol = values.getOrElse(1) { letter }
        val secondarySymbol = values.getOrElse(2) { primarySymbol }

        return when {
            isSymbolsMode && shiftState == ShiftState.CAPS_LOCK -> secondarySymbol
            isSymbolsMode -> primarySymbol
            shiftState != ShiftState.OFF -> letter.uppercase()
            else -> letter
        }
    }

    private fun resolveKeyValue(spec: String): String {
        return resolveKeyLabel(spec)
    }

    private fun resolveAlternateKeyValue(spec: String): String? {
        val values = spec.split('|')
        return when {
            values.size >= 3 && isSymbolsMode -> values[2]
            values.size >= 2 && !isSymbolsMode -> values[1]
            else -> null
        }?.takeIf { it.isNotBlank() }
    }

    private fun collectCharacterButtons(root: View): List<Button> {
        val buttons = mutableListOf<Button>()

        fun walk(view: View) {
            if (view is Button && view.tag is String) {
                buttons += view
                return
            }

            if (view is ViewGroup) {
                for (index in 0 until view.childCount) {
                    walk(view.getChildAt(index))
                }
            }
        }

        walk(root)
        return buttons
    }

    private fun startBackspaceRepeat() {
        backspaceRepeatJob?.cancel()
        backspaceRepeatJob = serviceScope.launch {
            delay(240)
            var repeatDelay = 70L
            while (true) {
                handleBackspace()
                delay(repeatDelay)
                if (repeatDelay > 35L) {
                    repeatDelay -= 5L
                }
            }
        }
    }

    private fun stopBackspaceRepeat() {
        backspaceRepeatJob?.cancel()
        backspaceRepeatJob = null
    }

    private fun refreshNativeSettings() {
        val preferences = getSharedPreferences(PREFERENCES_NAME, Context.MODE_PRIVATE)
        val storedPair = preferences.getString(SELECTED_PAIR_KEY, DEFAULT_PAIR)
        val pairParts = storedPair?.split(':').orEmpty()
        val source = pairParts.getOrNull(0)?.uppercase() ?: "EN"
        targetLanguage = pairParts.getOrNull(1) ?: "am"
        isHapticFeedbackEnabled = preferences.getBoolean(HAPTIC_FEEDBACK_KEY, true)
        isSoundFeedbackEnabled = preferences.getBoolean(SOUND_FEEDBACK_KEY, false)
        pairIndicatorTextView.text = getString(
            R.string.active_pair_format,
            source,
            targetLanguage.uppercase(),
        )
    }

    private fun advanceShiftState() {
        val now = SystemClock.elapsedRealtime()
        shiftState = when {
            shiftState == ShiftState.CAPS_LOCK -> ShiftState.OFF
            now - lastShiftTapAt <= SHIFT_DOUBLE_TAP_WINDOW_MS -> ShiftState.CAPS_LOCK
            shiftState == ShiftState.OFF -> ShiftState.ONCE
            else -> ShiftState.OFF
        }
        lastShiftTapAt = now
        refreshKeyboardState()
    }

    private fun performKeyFeedback(type: FeedbackType) {
        if (isHapticFeedbackEnabled) {
            feedbackAnchorView.performHapticFeedback(HapticFeedbackConstants.KEYBOARD_TAP)
        }

        if (!isSoundFeedbackEnabled) {
            return
        }

        feedbackAnchorView.playSoundEffect(
            when (type) {
                FeedbackType.STANDARD -> SoundEffectConstants.CLICK
                FeedbackType.DELETE -> SoundEffectConstants.CLICK
                FeedbackType.SPACE -> SoundEffectConstants.CLICK
                FeedbackType.RETURN -> SoundEffectConstants.CLICK
            },
        )
    }

    private fun updatePreviewStatus(value: String) {
        if (statusTextView.text == value) {
            return
        }

        statusTextView.animate().cancel()
        statusTextView.animate().alpha(0.35f).setDuration(60).withEndAction {
            statusTextView.text = value
            statusTextView.animate().alpha(1f).setDuration(110).start()
        }.start()
    }

    private fun updatePreviewText(value: String) {
        if (suggestionTextView.text == value) {
            return
        }

        suggestionTextView.animate().cancel()
        suggestionTextView.animate().alpha(0.5f).setDuration(70).withEndAction {
            suggestionTextView.text = value
            suggestionTextView.animate().alpha(1f).setDuration(130).start()
        }.start()
    }

    private enum class ShiftState {
        OFF,
        ONCE,
        CAPS_LOCK,
    }

    private enum class FeedbackType {
        STANDARD,
        DELETE,
        SPACE,
        RETURN,
    }

    companion object {
        private const val PREFERENCES_NAME = "FlutterSharedPreferences"
        private const val SELECTED_PAIR_KEY = "flutter.selected_language_pair"
        private const val HAPTIC_FEEDBACK_KEY = "flutter.haptic_feedback_enabled"
        private const val SOUND_FEEDBACK_KEY = "flutter.sound_feedback_enabled"
        private const val DEFAULT_PAIR = "en:am"
        private const val SHIFT_DOUBLE_TAP_WINDOW_MS = 300L
    }
}
