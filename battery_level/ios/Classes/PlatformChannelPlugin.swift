import Flutter
import UIKit

public class PlatformChannelPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
  private var _eventSink: FlutterEventSink? = nil
  private var _count: Int = 0
  private var messageChannel: FlutterBasicMessageChannel?
  private var _timer: Timer? = nil

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "samples.flutter.io/battery", binaryMessenger: registrar.messenger())
    let instance = PlatformChannelPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    // create even channel
    let evenChannel = FlutterEventChannel(name: "samples.flutter.io/charging", binaryMessenger: registrar.messenger())
    evenChannel.setStreamHandler(instance)
    // create basic message channel
    instance.messageChannel = FlutterBasicMessageChannel(name: "samples.flutter.io/message", binaryMessenger: registrar.messenger(),
                                                         codec: FlutterStringCodec.sharedInstance())
    // 也可以监听 Dart 端传来的消息（双向的！）
    instance.messageChannel?.setMessageHandler { message, reply in
      print("Received from Dart: \(message ?? "nil")")
      reply("iOS got your message!(\(message ?? ""))")
    }
    // 举例：延迟 3 秒后发送一条消息给 Dart
    // DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
    //   messageChannel.sendMessage("Hello from iOS 🎯")
    // }
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
    case "increaseCounter":
      _count += 1
      result(_count)
      sendCountEvent()
    case "decreaseCounter":
      _count -= 1
      result(_count)
      sendCountEvent()
    case "startTimer":
      if _timer == nil {
        _timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
          self.messageChannel?.sendMessage("Hello from iOS 🍎")
        }
        RunLoop.current.add(_timer!, forMode: .common)
      }
    case "stopTimer":
      _timer?.invalidate()
      _timer = nil
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  // MARK: - EventChannel implement FlutterStreamHandler

  public func onListen(withArguments _: Any?,
                       eventSink: @escaping FlutterEventSink) -> FlutterError?
  {
    _eventSink = eventSink
    let name = Notification.Name("counter.tick")
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(onCountChange), name: name, object: nil
    )
    // send an initial state immediately
    sendCountEvent()
    return nil
  }

  @objc private func onCountChange(notification _: NSNotification) {
    sendCountEvent()
  }

  private func sendCountEvent() {
    guard let _eventSink = _eventSink else {
      return
    }
    _eventSink(_count)
  }

  public func onCancel(withArguments _: Any?) -> FlutterError? {
    NotificationCenter.default.removeObserver(self)
    _eventSink = nil
    _count = 0
    return nil
  }
}
