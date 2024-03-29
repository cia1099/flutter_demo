# i_am_poor

Integrated Google pay and ADBs project with flutter

## Getting Started

```shell
flutter create . --platforms=android,ios
flutter pub get
```
## App Icon
https://www.youtube.com/watch?v=QPVMaedX1W8\
https://www.youtube.com/watch?v=eMHbgIgJyUQ

改变app的icon我们在`pubspec.yaml`的`dev_dependencies:`下安装`flutter_launcher_icons`。\
然后在下面加上，注意yaml的缩近排版
```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.13.1

flutter_launcher_icons:
  android: "launcher_icon"
  ios: "AppIcon"
  image_path: "assets/icon2.png"
  min_sdk_android: 21
  remove_alpha_ios: true
  adaptive_icon_background: "#000000"
  adaptive_icon_foreground: assets/play_store_512.png
```
执行命令：
```shell
flutter pub get && flutter pub run flutter_launcher_icons
```

* 修复安卓icon外面白边距的问题
[Android Studio Icon Generator](https://romannurik.github.io/AndroidAssetStudio/icons-launcher.html#foreground.type=clipart&foreground.clipart=android&foreground.space.trim=1&foreground.space.pad=0.25&foreColor=rgba(96%2C%20125%2C%20139%2C%200)&backColor=rgb(68%2C%20138%2C%20255)&crop=0&backgroundShape=circle&effects=none&name=ic_launcher)\
可以将Padding调整为0，这样让整个图片占满icon的范围。

## 打包发布到Google Play
[发布官方文档](https://docs.flutter.dev/deployment/android)
* 生成安卓keystore
```shell
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA \
        -keysize 2048 -validity 10000 -alias upload
# 使用该指令生成会有一系列的问题，记得要记住该keystore的密码
```
其中keytool是java的指令，只要有正常安装flutter都可以使用该指令。
* 将keystore引用到app
创建`path/to/project/android/key.properties`
```properties
storePassword=<password-from-previous-step>
keyPassword=<password-from-previous-step>
keyAlias=upload
storeFile=<keystore-file-location>
```
The storeFile might be located at `~/upload-keystore.jks`
* 设定编辑发布版`android/build.gradle`的参数
1. Add the keystore information from your properties file before the android block:
```gradle
   def keystoreProperties = new Properties()
   def keystorePropertiesFile = rootProject.file('key.properties')
   if (keystorePropertiesFile.exists()) {
       keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
   }

   android {
         ...
   }
```
Load the key.properties file into the keystoreProperties object.
2. Find the buildTypes block:
```gradle
   buildTypes {
       release {
           // TODO: Add your own signing config for the release build.
           // Signing with the debug keys for now,
           // so `flutter run --release` works.
           signingConfig signingConfigs.debug
       }
   }
// And replace it with the following signing configuration info:
   signingConfigs {
       release {
           keyAlias keystoreProperties['keyAlias']
           keyPassword keystoreProperties['keyPassword']
           storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
           storePassword keystoreProperties['storePassword']
       }
   }
   buildTypes {
       release {
           signingConfig signingConfigs.release
       }
   }
```
Release builds of your app will now be signed automatically.
<div class="warning" style='background-color:#E9D8FD; color:#69337A'>

__NOTE__: You might need to run flutter clean after changing the gradle file. This prevents cached builds from affecting the signing process.
</div>

* 打包上传需要的.aab包
```shell
flutter clean && flutter pub get && flutter pub run flutter_launcher_icons&&\
flutter build appbundle --release
```
## Privacy Policy
使用[TermsFeed](https://www.termsfeed.com/?utm_source=Article-318&utm_medium=PDF&utm_campaign=How-to-PDF)来生成privacy条款网址。


## Google Mobile ADs
[AdMob official document](https://docs.flutter.dev/cookbook/plugins/google-mobile-ads)\
这里使用的账号是cia1099@gmail.com因为个人资料的问题需要用个人账户。

## SetUp Google Pay
我使用的账号是cia1099@gapp.nthu.edu.tw，和Google play的账号相同

[android](https://developers.google.com/pay/api/android/guides/setup)
* App prerequisites
在`android/app/build.gradle`的`minSdkVersion`最少要 21 或更高。
```gradle
defaultConfig {
        minSdkVersion 21
    }
```
* App dependencies
`android/app/build.gradle`
```gradle
dependencies {
    implementation 'com.google.android.gms:play-services-wallet:19.3.0'
}
```
* Modify your manifest
`android/app/src/main/AndroidManifest.xml`
```xml
<application>
    <meta-data
        android:name="com.google.android.gms.wallet.api.enabled"
        android:value="true" />
</application>
```

支付的设定档参数可以参考这\
https://medium.com/@gauravswarankar/gpay-in-flutter-958c8b856f0b

测试手机要登入google账号，而且账号要有绑定google pay才能有作用。