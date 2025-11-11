import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onnxruntime/flutter_onnxruntime.dart';
import 'package:statsfl/statsfl.dart';

import 'frosted_button.dart';
import 'pages/detect_page.dart';
import 'pages/dev_page.dart';

void main() {
  runApp(
    StatsFl(align: Alignment(1, -.9), isEnabled: true, child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'YOLO Demo',
      // theme: CupertinoThemeData(
      //   brightness: Brightness.light,
      //   primaryColor: CupertinoColors.activeBlue,
      // ),
      // theme: MaterialBasedCupertinoThemeData(
      //   materialTheme: ThemeData(
      //     colorScheme: ColorScheme.fromSeed(
      //       seedColor: Color(0xff003153),
      //       // brightness: Brightness.dark,
      //     ),
      //     useMaterial3: true,
      //     cupertinoOverrideTheme: CupertinoThemeData(applyThemeToAll: true),
      //   ),
      // ),
      // showPerformanceOverlay: true,
      debugShowCheckedModeBanner: false,
      // home: const MyHomePage(title: 'YOLO Demo Home Page'),
      home: const DevPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var cameras = <CameraDescription>[];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        middle: Text(widget.title),
        leading: FutureBuilder(
          future: OnnxRuntime().getAvailableProviders(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return SizedBox.shrink();
            return MenuBar(
              children: [
                SubmenuButton(
                  menuChildren: snapshot.data!.map((p) {
                    return Text(p.name);
                  }).toList(),
                  child: Text("EP"),
                ),
              ],
            );
          },
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Open Camera to detect objects'),
            FrostedButton(
              onPressed: () async {
                cameras = await availableCameras();
                print("We have cameras: ${cameras.length}");
                print("Lens rotated: ${cameras.last.sensorOrientation}");
                if (cameras.isNotEmpty && context.mounted) {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => DetectPage(
                        camera: cameras.firstWhere(
                          (c) => c.lensDirection == CameraLensDirection.back,
                        ),
                      ),
                      fullscreenDialog: true,
                      settings: RouteSettings(name: "detect"),
                    ),
                  );
                }
              },
              icon: CupertinoIcons.camera,
              size: 100,
            ),
          ],
        ),
      ),
    );
  }
}
