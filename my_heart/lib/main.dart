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
        child: CustomPaint(
          foregroundPainter: HeartPainter(
            bodyColor: Theme.of(context).scaffoldBackgroundColor,
            isShallow: true,
          ),
          child: Scratcher(
            brushSize: 30,
            threshold: 50,
            color: Colors.grey,
            rebuildOnResize: false,
            onChange: (value) => print("Scratch progress: $value%"),
            onThreshold: () => print("Threshold reached, you won!"),
            child: Container(
              height: 800,
              width: 880,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage("https://picsum.photos/300/300"),
                      fit: BoxFit.cover)),
            ),
          ),
        ),
        // child: FutureBuilder<ui.Image>(
        //   future: dartDecodeImage("https://picsum.photos/300/300", context),
        //   builder: (context, snapshot) {
        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       return const CircularProgressIndicator.adaptive();
        //     }
        //     final img = snapshot.data!;
        //     return CustomPaint(
        //       foregroundPainter: ImagePaiter(
        //           image: img,
        //           wallColor: Theme.of(context).scaffoldBackgroundColor),
        //       child: Scratcher(
        //         brushSize: 30,
        //         threshold: 50,
        //         color: Colors.grey,
        //         rebuildOnResize: false,
        //         onChange: (value) => print("Scratch progress: $value%"),
        //         onThreshold: () => print("Threshold reached, you won!"),
        //         child: Container(
        //           width: img.width.toDouble(),
        //           height: img.height.toDouble(),
        //           decoration: BoxDecoration(
        //               image: DecorationImage(
        //                   image: NetworkImage("https://picsum.photos/300/300"),
        //                   fit: BoxFit.cover)),
        //         ),
        //       ),
        //     );
        // },
        // ),
      ),
    );
  }
}
