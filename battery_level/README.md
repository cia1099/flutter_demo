# Platform Channel Practice

基本上plugin名称决定好了，就最好在这个自动生成的plugin类里写和Dart的接口，因为Flutter会以这个类，自动生成代码，让原生引用，因此注册所有的逻辑都最好在这个起始的文件里面去完成。

[创建Plugin](https://docs.flutter.dev/packages-and-plugins/developing-packages#step-1-create-the-package-1)：
```sh
flutter create --org com.cia1099 --template=plugin --platforms=android,ios battery_level
```
[Example references](https://docs.flutter.dev/platform-integration/platform-channels#example)

## iOS platform
例如Swift的插件的代码都写在`ios/Classes/`这个路径下，再将所有的逻辑统一注册在一开始就生成的类`ios/Classes/BatteryLevelPlugin.swift`
```swift
public class BatteryLevelPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "battery_level", binaryMessenger: registrar.messenger())
    let instance = BatteryLevelPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    // 注册別的功能, important
    PlatformChannelPlugin.register(with: registrar)

  }
  //...
}
```
[GPT QA](https://chatgpt.com/share/68f078c7-86d4-8005-8530-3696d8cbb42c)


