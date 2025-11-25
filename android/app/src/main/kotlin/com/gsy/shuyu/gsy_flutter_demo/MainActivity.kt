package com.gsy.shuyu.gsy_flutter_demo

import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.demo/method_channel"
    private var methodChannel: MethodChannel? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // 创建 MethodChannel
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)

        // 设置方法调用处理器
        methodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "getBatteryLevel" -> {
                    val batteryLevel = getBatteryLevel()
                    if (batteryLevel != -1) {
                        result.success(batteryLevel)
                    } else {
                        result.error("UNAVAILABLE", "Battery level not available.", null)
                    }
                }
                "getPlatformVersion" -> {
                    val version = "Android ${Build.VERSION.RELEASE} (API ${Build.VERSION.SDK_INT})"
                    result.success(version)
                }
                "sendData" -> {
                    // 获取 Flutter 发送的数据
                    val data = call.arguments as? Map<String, Any>
                    if (data != null) {
                        val name = data["name"] as? String
                        val value = data["value"] as? Int
                        val timestamp = data["timestamp"] as? Long

                        // 处理数据
                        val response = "Received: name=$name, value=$value, timestamp=$timestamp"

                        // 可以主动调用 Flutter 的方法
                        methodChannel?.invokeMethod("onPlatformCallback", "Android processed your data")

                        result.success(response)
                    } else {
                        result.error("INVALID_ARGUMENT", "Invalid data format", null)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    /**
     * 获取电池电量
     */
    private fun getBatteryLevel(): Int {
        return try {
            val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
            batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        } catch (e: Exception) {
            -1
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        methodChannel?.setMethodCallHandler(null)
    }
}
