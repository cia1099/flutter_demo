import 'package:flutter/services.dart';

import 'battery_level_platform_interface.dart';

class BatteryLevel {
  Future<String?> getPlatformVersion() {
    return BatteryLevelPlatform.instance.getPlatformVersion();
  }

  Future<int?> getButteryLevel() {
    return BatteryLevelPlatform.instance.getBatteryLevel();
  }

  Stream<String?> batteryCharging() {
    return BatteryLevelPlatform.instance.batteryCharging();
  }
}

class PlatformChannel {
  static const MethodChannel _methodChannel = MethodChannel(
    'samples.flutter.io/battery',
  );
  static const EventChannel _eventChannel = EventChannel(
    'samples.flutter.io/charging',
  );
  static const _messageChannel = BasicMessageChannel(
    "samples.flutter.io/message",
    StringCodec(),
  );

  static Future<int?> getBatteryLevel() async {
    final int? batteryLevel = await _methodChannel.invokeMethod(
      'getBatteryLevel',
    );
    return batteryLevel;
  }

  static Future<int?> increaseCounter() async {
    return _methodChannel.invokeMethod<int?>('increaseCounter');
  }

  static Future<int?> decreaseCounter() async {
    return _methodChannel.invokeMethod<int?>('decreaseCounter');
  }

  static void startTimer() {
    _methodChannel.invokeMethod('startTimer');
  }

  static void stopTimer() {
    _methodChannel.invokeMethod('stopTimer');
  }

  static Stream<int?> listenCounter() {
    return _eventChannel.receiveBroadcastStream().map<int?>((data) => data);
  }

  static void setMessageHandler(Future<String> Function(String?) handler) {
    _messageChannel.setMessageHandler(handler);
  }

  static void sendMessage(
    String message, {
    Future<String?> Function(String?)? reply,
  }) {
    _messageChannel.send(message).then(reply ?? print);
  }
}
