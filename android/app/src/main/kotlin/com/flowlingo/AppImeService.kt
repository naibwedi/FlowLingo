package com.flowlingo

import android.inputmethodservice.InputMethodService
import android.view.MotionEvent
import android.view.View
import android.view.ViewGroup
import android.view.inputmethod.EditorInfo
import android.view.inputmethod.InputConnection
import android.widget.Button
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
    private val targetLanguage = "am"

    private lateinit var translationChannel: TranslationChannel
    private lateinit var suggestionTextView: TextView
    private lateinit var applyButton: Button
    private lateinit var shiftButton: Button
    private lateinit var symbolsButton: Button
    private lateinit var enterButton: Button
    private lateinit var characterButtons: List<Button>

    private var currentBuffer = StringBuilder()
    private var translatedCandidate: String? = null
    private var debounceJob: Job? = null
    private var backspaceRepeatJob: Job? = null
    private var isShiftEnabled = false
    private var isSymbolsMode = false

    override fun onCreate() {
        super.onCreate()
        translationChannel = TranslationChannel(AppEngineHolder.getOrCreate(application))
    }

    override fun onCreateInputView(): View {
        val view = layoutInflater.inflate(R.layout.keyboard_view, null)
        suggestionTextView = view.findViewById(R.id.translationSuggestion)
        applyButton = view.findViewById(R.id.applyTranslationButton)
        shiftButton = view.findViewById(R.id.keyShift)
        symbolsButton = view.findViewById(R.id.keySymbols)
        enterButton = view.findViewById(R.id.keyEnter)
        characterButtons = collectCharacterButtons(view)

        bindCharacterKeys()
        bindSpecialKeys(view)
        renderIdleState()
        refreshKeyboardState()

        return view
    }

    override fun onStartInputView(info: EditorInfo?, restarting: Boolean) {
        super.onStartInputView(info, restarting)
        resetSessionState()
        updateEnterKeyLabel(info)
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
                commitCharacter(resolveKeyValue(spec))
            }
        }
    }

    private fun bindSpecialKeys(root: View) {
        shiftButton.setOnClickListener {
            isShiftEnabled = !isShiftEnabled
            refreshKeyboardState()
        }

        symbolsButton.setOnClickListener {
            isSymbolsMode = !isSymbolsMode
            isShiftEnabled = false
            refreshKeyboardState()
        }

        applyButton.setOnClickListener { applyTranslation() }
        enterButton.setOnClickListener { handleEnter() }

        root.findViewById<Button>(R.id.keySpace).setOnClickListener {
            commitCharacter(" ")
        }

        root.findViewById<Button>(R.id.keyBackspace).setOnTouchListener { _, event ->
            when (event.actionMasked) {
                MotionEvent.ACTION_DOWN -> {
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

        if (isShiftEnabled && !isSymbolsMode && value.any { it.isLetter() }) {
            isShiftEnabled = false
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
                suggestionTextView.text = response.translatedText
                applyButton.isEnabled = true
            } else {
                translatedCandidate = null
                suggestionTextView.text = getString(R.string.translation_error)
                applyButton.isEnabled = false
            }
        }
    }

    private fun applyTranslation() {
        val translation = translatedCandidate ?: return
        val inputConnection = currentInputConnection ?: return
        replaceBufferedText(inputConnection, translation)
        currentBuffer = StringBuilder(translation)
        suggestionTextView.text = translation
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

        shiftButton.isSelected = isShiftEnabled
        shiftButton.text = if (isShiftEnabled) {
            getString(R.string.key_shift_on)
        } else {
            getString(R.string.key_shift)
        }

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
        isShiftEnabled = false
        isSymbolsMode = false
        renderIdleState()
        refreshKeyboardState()
    }

    private fun renderIdleState() {
        suggestionTextView.text = getString(R.string.translation_idle)
        applyButton.isEnabled = false
    }

    private fun renderPendingState() {
        suggestionTextView.text = getString(R.string.translation_pending)
        applyButton.isEnabled = false
    }

    private fun updateEnterKeyLabel(info: EditorInfo?) {
        enterButton.text = when (info?.imeOptions?.and(EditorInfo.IME_MASK_ACTION)) {
            EditorInfo.IME_ACTION_GO -> getString(R.string.key_go)
            EditorInfo.IME_ACTION_SEARCH -> getString(R.string.key_search)
            EditorInfo.IME_ACTION_SEND -> getString(R.string.key_send)
            EditorInfo.IME_ACTION_NEXT -> getString(R.string.key_next)
            EditorInfo.IME_ACTION_DONE -> getString(R.string.key_done)
            else -> getString(R.string.key_enter)
        }
    }

    private fun resolveKeyLabel(spec: String): String {
        val primary = spec.substringBefore('|')
        val alternate = spec.substringAfter('|', primary)
        val displayValue = if (isSymbolsMode) alternate else primary

        return if (!isSymbolsMode && isShiftEnabled) {
            displayValue.uppercase()
        } else {
            displayValue
        }
    }

    private fun resolveKeyValue(spec: String): String {
        val label = resolveKeyLabel(spec)
        return if (isSymbolsMode) label else label.lowercase().let {
            if (isShiftEnabled) label else it
        }
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
            delay(350)
            while (true) {
                handleBackspace()
                delay(75)
            }
        }
    }

    private fun stopBackspaceRepeat() {
        backspaceRepeatJob?.cancel()
        backspaceRepeatJob = null
    }
}
