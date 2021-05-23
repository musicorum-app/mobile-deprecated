package com.musicorumapp.mobile.musicorum

import android.content.pm.PackageManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val MISC_CHANNEL = "com.musicorumapp.mobile.musicorum/misc"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, MISC_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getVersionString") {
                try {
                    val version = getVersionString()
                    result.success(version)
                } catch (e: PackageManager.NameNotFoundException) {
                    result.error("PACKAGE_NAME_NOT_FOUND", e.message, e)
                }
            } else result.notImplemented()
        }
    }

    private fun getVersionString(): String {
        val packageInfo = context.packageManager.getPackageInfo(context.packageName, 0)
        return packageInfo.versionName
    }
}
