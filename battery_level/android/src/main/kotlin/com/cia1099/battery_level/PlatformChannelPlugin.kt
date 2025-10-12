package com.cia1099.battery_level

import android.content.Context

import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result


class PlatformChannelPlugin(private val context: Context): MethodCallHandler{//, EventChannel.StreamHandler {

  private var _count = 0

  override fun onMethodCall(call: MethodCall, result: Result) {
    when(call.method){
      "getBatteryLevel" -> result.success(100)
      "increaseCounter" -> {
        _count++
        result.success(_count)
      }
      "decreaseCounter" -> {
        _count--
        result.success(_count)
      }
      else -> {
        result.notImplemented()
      }
    }
  }
}