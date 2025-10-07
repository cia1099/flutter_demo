import 'package:battery_level/battery_level.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _batteryLevelPlugin = BatteryLevel();
  var _batteryLevel = '_';
  int? countFromNative;
  var platformMessage = 'From native: ...';
  var isPushFromNative = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    PlatformChannel.listenCounter().listen((event) {
      setState(() {
        countFromNative = event;
      });
    });
    PlatformChannel.setMessageHandler((message) async {
      setState(() {
        platformMessage = message ?? '...';
      });
      Future.delayed((Durations.extralong4), () {
        setState(() {
          platformMessage = 'From native: ...';
        });
      });
      return platformMessage;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _batteryLevelPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Plugin example app')),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Text(_batteryLevel)),
            ElevatedButton(
              onPressed: _getBatteryLevel,
              child: const Text('Get Battery Level'),
            ),
            Text('Running on: $_platformVersion\n'),
            StreamBuilder(
              stream: _batteryLevelPlugin.batteryCharging(),
              builder: (context, snapshot) {
                const defaultCharging = 'Battery status: unknown.';
                if (!snapshot.hasData || snapshot.hasError) {
                  return Text(defaultCharging);
                }
                return Text(
                  "Battery status: ${snapshot.data == 'charging' ? '' : 'dis'}charging.",
                );
              },
            ),
            Divider(),
            Text("Counter: $countFromNative"),
            CupertinoButton.filled(
              child: Text("Increase Counter"),
              onPressed: () {
                PlatformChannel.increaseCounter().then((value) {
                  // setState(() {
                  //   countFromNative = value;
                  // });
                });
              },
            ),
            CupertinoButton.tinted(
              child: Text("Decrease Counter"),
              onPressed: () {
                PlatformChannel.decreaseCounter().then((value) {
                  // setState(() {
                  //   countFromNative = value;
                  // });
                });
              },
            ),
            Divider(),
            Text(
              platformMessage,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            IconButton(
              onPressed: () {
                PlatformChannel.sendMessage(
                  "Hello I am flutter!",
                  reply: (message) async {
                    setState(() {
                      platformMessage = message ?? '...';
                    });
                    Future.delayed((Durations.extralong4), () {
                      setState(() {
                        platformMessage = 'From native: ...';
                      });
                    });
                    return message;
                  },
                );
              },
              icon: Icon(Icons.send),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 10,
              children: [
                Text("Push from native Switcher"),
                Switch.adaptive(
                  value: isPushFromNative,
                  onChanged: (value) {
                    value
                        ? PlatformChannel.startTimer()
                        : PlatformChannel.stopTimer();
                    setState(() {
                      isPushFromNative = value;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _getBatteryLevel() async {
    String batteryLevel;
    try {
      final result = await _batteryLevelPlugin.getButteryLevel();
      //await PlatformChannel.getBatteryLevel();
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }
}
