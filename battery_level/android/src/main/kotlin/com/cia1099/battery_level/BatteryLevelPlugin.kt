package com.cia1099.battery_level

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.StringCodec

import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import android.content.BroadcastReceiver

/** BatteryLevelPlugin */
class BatteryLevelPlugin: FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler {

  private lateinit var channel : MethodChannel
  private lateinit var charging: EventChannel
  //register external plugin
  private lateinit var platformHandler : PlatformChannelPlugin
  private lateinit var platformChannel : MethodChannel
  private lateinit var platformEventChannel: EventChannel


  private lateinit var context : Context //in order to getSystemService

  // EventChannel 的事件下发器与接收器引用，便于取消注册
  private var events: EventChannel.EventSink? = null
  private var batteryReceiver: BroadcastReceiver? = null

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    context = flutterPluginBinding.applicationContext
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "battery_level")
    channel.setMethodCallHandler(this)
    //message 这个无法用Interface(PlatformChannelPlugin)来化简，因为需要传入FlutterPlugin
    val messageChannel = BasicMessageChannel(flutterPluginBinding.binaryMessenger, "samples.flutter.io/message", StringCodec.INSTANCE)
    messageChannel.setMessageHandler { message, reply ->
      println("Received from Dart: $message")
      // 回复 Flutter
      reply.reply("Android got your message!($message)")
    }
    //MARK: - external handler
    platformHandler = PlatformChannelPlugin(context, messageChannel)
    platformChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "samples.flutter.io/battery")
    platformChannel.setMethodCallHandler(platformHandler)
    //create even
    charging = EventChannel(flutterPluginBinding.binaryMessenger, "battery_charging")
    charging.setStreamHandler(this)
    platformEventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "samples.flutter.io/charging")
    platformEventChannel.setStreamHandler(platformHandler)
  }

  // MARK: - Method Channel
  override fun onMethodCall(call: MethodCall, result: Result) {
    if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } 
    else if(call.method == "getBatteryLevel"){
      val batteryLevel = getBatteryLevel()
        if (batteryLevel != -1) {
          result.success(batteryLevel)
        } else {
          result.error("UNAVAILABLE", "Battery level not available.", null)
        }
    }
    else {
      result.notImplemented()
    }
  }

  private fun getBatteryLevel(): Int {
    val batteryLevel: Int
    if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
      val batteryManager = context.getSystemService(Context.BATTERY_SERVICE) as BatteryManager
      batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
    } else {
      val intent = ContextWrapper(context).registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
      batteryLevel = intent!!.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100 / intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
    }

    return batteryLevel
  }

  // MARK: - Event Channel
  override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
    this.events = events
    // 1) 先立即推一次当前电量（可选）
    val current = getBatteryLevel()
    if (current != -1) {
      this.events?.success(current)
    }
    // 2) 注册系统电池广播，后续有变化时推送
    if (batteryReceiver == null) {
      batteryReceiver = object : BroadcastReceiver() {
        override fun onReceive(ctx: Context?, intent: Intent?) {
          if (intent?.action == Intent.ACTION_BATTERY_CHANGED) {
            val level = intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1)
            val scale = intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
            if (level >= 0 && scale > 0) {
              val percent = level * 100 / scale
              this@BatteryLevelPlugin.events?.success(percent)
            }
          }
        }
      }
      context.registerReceiver(batteryReceiver, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
    }
  }
  // EventChannel: Dart 取消监听
  override fun onCancel(arguments: Any?) {
    if (batteryReceiver != null) {
      try {
        context.unregisterReceiver(batteryReceiver)
      } catch (_: IllegalArgumentException) {
        // 已经被注销时忽略
      }
      batteryReceiver = null
    }
    events = null
  }
  
  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
    platformChannel.setMethodCallHandler(null)
    platformEventChannel.setStreamHandler(null)
    charging.setStreamHandler(null)
    onCancel(null)
  }
}


