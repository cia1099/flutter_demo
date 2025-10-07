import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'battery_level_method_channel.dart';

abstract class BatteryLevelPlatform extends PlatformInterface {
  /// Constructs a BatteryLevelPlatform.
  BatteryLevelPlatform() : super(token: _token);

  static final Object _token = Object();

  static BatteryLevelPlatform _instance = MethodChannelBatteryLevel();

  /// The default instance of [BatteryLevelPlatform] to use.
  ///
  /// Defaults to [MethodChannelBatteryLevel].
  static BatteryLevelPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BatteryLevelPlatform] when
  /// they register themselves.
  static set instance(BatteryLevelPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<int?> getBatteryLevel() {
    throw UnimplementedError('getBatteryLevel() has not been implemented.');
  }

  Stream<String?> batteryCharging() {
    throw UnimplementedError('batteryCharging() has not been implemented.');
  }
}
