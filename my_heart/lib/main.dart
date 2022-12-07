import 'dart:ui' as ui show Image;

import 'package:flutter/material.dart';
import 'package:my_heart/heart.dart';
import 'package:my_heart/utilts.dart';
import 'package:scratcher/scratcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Honey',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'My Honey Demo Home Page'),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        // child: HeartAnimation(
        //     duration: Duration(seconds: 3),
        //     bodyColor: Color(0xFFF27788),
        //     borderColor: Color.fromARGB(255, 41, 17, 9),
        //     borderWith: 12,
        //     size: Size(880, 800)),
        // child: Scratcher(
        //   brushSize: 30,
        //   threshold: 50,
        //   color: Colors.grey,
        //   rebuildOnResize: false,
        //   onChange: (value) => print("Scratch progress: $value%"),
        //   onThreshold: () => print("Threshold reached, you won!"),
        //   child: Container(
        //     height: 400,
        //     width: 440,
        //     child: CustomPaint(
        //       painter: HeartPainter(
        //         bodyColor: Color(0xFFF27788),
        //       ),
        //     ),
        //   ),
        // ),
        child: FutureBuilder<ui.Image>(
          future: dartDecodeImage("https://picsum.photos/300/300", context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator.adaptive();
            }
            return CustomPaint(
              painter: TestPainter(
                  image: snapshot.data!,
                  wallColor: Theme.of(context).scaffoldBackgroundColor),
            );
          },
        ),
      ),
    );
  }
}

class TestPainter extends CustomPainter {
  final ui.Image image;
  Color? wallColor;

  TestPainter({required this.image, this.wallColor});

  @override
  void paint(Canvas canvas, Size size) {
    double width = size.width;
    double height = size.height;
    final lt =
        Offset(width / 2 - image.width / 2, height / 2 - image.height / 2);
    canvas.drawImage(image, lt, Paint());
    //ref. https://stackoverflow.com/questions/59626727/how-to-erase-clip-from-canvas-custompaint
    canvas.saveLayer(Rect.largest, Paint());
    canvas.drawRect(
        Rect.fromLTWH(
            lt.dx, lt.dy, image.width.toDouble(), image.height.toDouble()),
        Paint()..color = wallColor ?? Colors.white);
    final heartPatten =
        heartGraph(Size(image.width.toDouble(), image.height.toDouble()));

    canvas.drawPath(heartPatten, Paint()..blendMode = BlendMode.clear);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
