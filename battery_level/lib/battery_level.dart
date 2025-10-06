import 'package:flutter/services.dart';

import 'battery_level_platform_interface.dart';

class BatteryLevel {
  Future<String?> getPlatformVersion() {
    return BatteryLevelPlatform.instance.getPlatformVersion();
  }
}

class PlatformChannel {
  static const MethodChannel _methodChannel = MethodChannel(
    'samples.flutter.io/battery',
  );
  static const EventChannel _eventChannel = EventChannel(
    'samples.flutter.io/charging',
  );

  static Future<int?> getBatteryLevel() async {
    final int? batteryLevel = await _methodChannel.invokeMethod(
      'getBatteryLevel',
    );
    return batteryLevel;
  }
}
