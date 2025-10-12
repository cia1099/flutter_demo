import Flutter
import UIKit

// ref. https://github.com/flutter/flutter/blob/main/examples/platform_channel_swift/ios/Runner/AppDelegate.swift
public class BatteryLevelPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
  private var eventSink: FlutterEventSink?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "battery_level", binaryMessenger: registrar.messenger())
    let instance = BatteryLevelPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    // 注册別的功能, important
    PlatformChannelPlugin.register(with: registrar)
    // create even channel
    let charging = FlutterEventChannel(name: "battery_charging", binaryMessenger: registrar.messenger())
    charging.setStreamHandler(instance)
  }

  // MARK: - MethodChannel

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "getBatteryLevel":
      let device = UIDevice.current
      device.isBatteryMonitoringEnabled = true
      let batteryLevel = device.batteryLevel

      if batteryLevel == -1 {
        result(FlutterError(code: "UNAVAILABLE",
                            message: "Battery info unavailable",
                            details: nil))
      } else {
        result(Int(batteryLevel * 100))
      }
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  // MARK: - EventChannel implement FlutterStreamHandler

  public func onListen(withArguments _: Any?,
                       eventSink: @escaping FlutterEventSink) -> FlutterError?
  {
    self.eventSink = eventSink
    UIDevice.current.isBatteryMonitoringEnabled = true
    sendBatteryStateEvent()
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(onBatteryStateDidChange),
      name: UIDevice.batteryStateDidChangeNotification,
      object: nil
    )
    return nil
  }

  @objc private func onBatteryStateDidChange(notification _: NSNotification) {
    sendBatteryStateEvent()
  }

  private func sendBatteryStateEvent() {
    guard let eventSink = eventSink else {
      return
    }

    switch UIDevice.current.batteryState {
    case .full:
      eventSink("full")
    case .charging:
      eventSink("charging")
    case .unplugged:
      eventSink("discharging")
    default:
      eventSink("unknown")
      // eventSink(FlutterError(code: MyFlutterErrorCode.unavailable,
      //                        message: "Charging status unavailable",
      //                        details: nil))
    }
  }

  public func onCancel(withArguments _: Any?) -> FlutterError? {
    NotificationCenter.default.removeObserver(self)
    eventSink = nil
    return nil
  }
}
