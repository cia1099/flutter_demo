import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'battery_level_platform_interface.dart';

/// An implementation of [BatteryLevelPlatform] that uses method channels.
class MethodChannelBatteryLevel extends BatteryLevelPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('battery_level');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }

  @override
  Future<int?> getBatteryLevel() async {
    final int? batteryLevel = await methodChannel.invokeMethod<int>(
      'getBatteryLevel',
    );
    return batteryLevel;
  }
}
