package com.flowlingo

import android.app.Application
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.embedding.engine.loader.FlutterLoader
import io.flutter.embedding.engine.plugins.util.GeneratedPluginRegister

class AppApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        AppEngineHolder.getOrCreate(this)
    }
}

object AppEngineHolder {
    @Volatile
    private var engine: FlutterEngine? = null

    fun getOrCreate(application: Application): FlutterEngine {
        return engine ?: synchronized(this) {
            engine ?: buildEngine(application).also { engine = it }
        }
    }

    private fun buildEngine(application: Application): FlutterEngine {
        val flutterLoader = FlutterLoader()
        flutterLoader.startInitialization(application)
        flutterLoader.ensureInitializationComplete(application, emptyArray())

        return FlutterEngine(application).apply {
            if (!dartExecutor.isExecutingDart) {
                dartExecutor.executeDartEntrypoint(DartExecutor.DartEntrypoint.createDefault())
            }
            GeneratedPluginRegister.registerGeneratedPlugins(this)
        }
    }
}
