package com.flowlingo

import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CompletableDeferred
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

class TranslationChannel(engine: FlutterEngine) {
    private val channel = MethodChannel(engine.dartExecutor.binaryMessenger, CHANNEL_NAME)

    suspend fun translate(text: String, targetLang: String): TranslationResponse =
        withContext(Dispatchers.Main.immediate) {
            val deferred = CompletableDeferred<TranslationResponse>()

            channel.invokeMethod(
                METHOD_TRANSLATE,
                mapOf("text" to text, "targetLang" to targetLang),
                object : MethodChannel.Result {
                    override fun success(result: Any?) {
                        val payload = result as? Map<*, *>
                        val translatedText = payload?.get("translatedText") as? String
                        val responseTarget = payload?.get("targetLang") as? String ?: targetLang

                        if (translatedText.isNullOrBlank()) {
                            deferred.complete(TranslationResponse.failure(responseTarget))
                            return
                        }

                        deferred.complete(
                            TranslationResponse.success(
                                translatedText = translatedText,
                                targetLang = responseTarget,
                            ),
                        )
                    }

                    override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                        deferred.complete(TranslationResponse.failure(targetLang))
                    }

                    override fun notImplemented() {
                        deferred.complete(TranslationResponse.failure(targetLang))
                    }
                },
            )

            deferred.await()
        }

    companion object {
        const val CHANNEL_NAME = "com.keylingo/translation"
        const val METHOD_TRANSLATE = "translate"
    }
}

data class TranslationResponse(
    val translatedText: String?,
    val targetLang: String,
    val isSuccess: Boolean,
) {
    companion object {
        fun success(translatedText: String, targetLang: String): TranslationResponse {
            return TranslationResponse(
                translatedText = translatedText,
                targetLang = targetLang,
                isSuccess = true,
            )
        }

        fun failure(targetLang: String): TranslationResponse {
            return TranslationResponse(
                translatedText = null,
                targetLang = targetLang,
                isSuccess = false,
            )
        }
    }
}
