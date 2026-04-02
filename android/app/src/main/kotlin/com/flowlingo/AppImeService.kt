package com.flowlingo

import android.inputmethodservice.InputMethodService
import android.view.KeyEvent
import android.view.View
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

    private var currentBuffer = StringBuilder()
    private var translatedCandidate: String? = null
    private var debounceJob: Job? = null

    override fun onCreate() {
        super.onCreate()
        translationChannel = TranslationChannel(AppEngineHolder.getOrCreate(application))
    }

    override fun onCreateInputView(): View {
        val view = layoutInflater.inflate(R.layout.keyboard_view, null)
        suggestionTextView = view.findViewById(R.id.translationSuggestion)
        applyButton = view.findViewById(R.id.applyTranslationButton)

        bindKey(view, R.id.keyA, "a")
        bindKey(view, R.id.keyB, "b")
        bindKey(view, R.id.keyC, "c")
        bindKey(view, R.id.keyD, "d")
        bindKey(view, R.id.keyE, "e")
        bindKey(view, R.id.keySpace, " ")

        view.findViewById<Button>(R.id.keyBackspace).setOnClickListener { handleBackspace() }
        applyButton.setOnClickListener { applyTranslation() }

        renderIdleState()
        return view
    }

    override fun onStartInputView(info: EditorInfo?, restarting: Boolean) {
        super.onStartInputView(info, restarting)
        currentBuffer = StringBuilder()
        translatedCandidate = null
        debounceJob?.cancel()
        renderIdleState()
    }

    override fun onFinishInputView(finishingInput: Boolean) {
        debounceJob?.cancel()
        super.onFinishInputView(finishingInput)
    }

    override fun onDestroy() {
        serviceScope.cancel()
        super.onDestroy()
    }

    private fun bindKey(parent: View, keyId: Int, value: String) {
        parent.findViewById<Button>(keyId).setOnClickListener {
            commitText(value)
        }
    }

    private fun commitText(value: String) {
        currentInputConnection?.commitText(value, 1)
        currentBuffer.append(value)
        translatedCandidate = null
        renderPendingState()
        scheduleTranslation()
    }

    private fun handleBackspace() {
        val inputConnection = currentInputConnection ?: return
        if (currentBuffer.isNotEmpty()) {
            currentBuffer.deleteAt(currentBuffer.length - 1)
            inputConnection.deleteSurroundingText(1, 0)
        } else {
            inputConnection.sendKeyEvent(KeyEvent(KeyEvent.ACTION_DOWN, KeyEvent.KEYCODE_DEL))
            inputConnection.sendKeyEvent(KeyEvent(KeyEvent.ACTION_UP, KeyEvent.KEYCODE_DEL))
        }

        translatedCandidate = null
        if (currentBuffer.isEmpty()) {
            debounceJob?.cancel()
            renderIdleState()
        } else {
            renderPendingState()
            scheduleTranslation()
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

    private fun renderIdleState() {
        suggestionTextView.text = getString(R.string.translation_idle)
        applyButton.isEnabled = false
    }

    private fun renderPendingState() {
        suggestionTextView.text = getString(R.string.translation_pending)
        applyButton.isEnabled = false
    }
}
