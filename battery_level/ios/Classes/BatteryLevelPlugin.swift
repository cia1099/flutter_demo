import Flutter
import UIKit

public class BatteryLevelPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "battery_level", binaryMessenger: registrar.messenger())
    let instance = BatteryLevelPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}

public class PlatformChannelPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "samples.flutter.io/battery", binaryMessenger: registrar.messenger())
    let instance = PlatformChannelPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
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
}
