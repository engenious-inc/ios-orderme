package com.example.app

import android.app.Application
import android.content.Context
import android.util.Log

object BaseUrlProvider {
    private const val TAG = "BaseUrlProvider"
    private const val DEFAULT_BASE = "https://api.example.com"

    // Читаем из SharedPreferences, а также из системных пропертей (если есть)
    fun get(context: Context): String {
        val prefs = context.getSharedPreferences("e2e", Context.MODE_PRIVATE)
        val fromPrefs = prefs.getString("BASE_URL", null)
        if (!fromPrefs.isNullOrBlank()) return fromPrefs

        // В CI можно прокинуть через системные проперти
        val fromProp = System.getProperty("BASE_URL") ?: System.getenv("BASE_URL")
        if (!fromProp.isNullOrBlank()) return fromProp

        return DEFAULT_BASE
    }

    fun saveFromLaunchArg(app: Application, extras: android.os.Bundle?) {
        extras?.getString("BASE_URL")?.let {
            Log.d(TAG, "Using BASE_URL from launch arguments: $it")
            app.getSharedPreferences("e2e", Context.MODE_PRIVATE)
                .edit().putString("BASE_URL", it).apply()
        }
    }
}
