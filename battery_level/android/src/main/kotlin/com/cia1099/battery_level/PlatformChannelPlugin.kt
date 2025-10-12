package com.cia1099.battery_level

import android.content.Context
import android.content.*
import android.os.*


import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.EventChannel


class PlatformChannelPlugin(private val context: Context): MethodCallHandler, EventChannel.StreamHandler {
  private var sink: EventChannel.EventSink? = null
  private val mainHandler = Handler(Looper.getMainLooper())
  private var _count = 0
  // MARK: - Method channel
  override fun onMethodCall(call: MethodCall, result: Result) {
    when(call.method){
      "getBatteryLevel" -> result.success(100)
      "increaseCounter" -> {
        _count++
        result.success(_count)
        emitCount(_count)
      }
      "decreaseCounter" -> {
        _count--
        result.success(_count)
        emitCount(_count)
      }
      else -> {
        result.notImplemented()
      }
    }
  }
  // MARK: - Event channel
  override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
    sink = events
    emitCount(_count)
  }
  override fun onCancel(arguments: Any?) {
    sink = null
  }
  private fun emitCount(value: Int) {
    /**
    所有 UI 操作、以及 Flutter 的 EventSink.success() 
    这种与平台通道交互的回调，必须在主线程执行。
    如果你去掉 mainHandler，然后在后台线程调用 sink.success()，
    可能会导致 Flutter 平台通道崩溃 或 UI 更新失败。
     */
    if (Looper.myLooper() == Looper.getMainLooper()) {
      sink?.success(value)
    } else {
      mainHandler.post { sink?.success(value) }
    }
  }
}