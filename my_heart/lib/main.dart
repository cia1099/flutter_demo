import 'dart:ui' as ui show Image, Gradient;

import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:my_heart/heart.dart';
import 'package:my_heart/node/fireworks_node.dart';
import 'package:my_heart/utilts.dart';
import 'package:scratcher/scratcher.dart';
import 'package:spritewidget/spritewidget.dart';

import 'happy_newyear_card.dart';

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
    final scenery = Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              Colors.blue[900]!,
            ],
          ),
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
    );
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
        //===== Heart Text
        child: CustomPaint(
          foregroundPainter: HeartPainter(
            bodyColor: Theme.of(context).scaffoldBackgroundColor,
            isShallow: true,
          ),
          // child: Scratcher(
          //   brushSize: 30,
          //   threshold: 50,
          //   color: Colors.grey,
          //   rebuildOnResize: false,
          //   onChange: (value) => print("Scratch progress: $value%"),
          //   onThreshold: () => print("Threshold reached, you won!"),
          child: Container(
            height: 800,
            width: 880,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage("https://picsum.photos/300/300"),
                    fit: BoxFit.cover)),
            child: BorderedText(
              strokeWidth: 1.5,
              child: Text(
                "1312313123144355\ndasdadadsaddfs\n干你老鸡巴",
                style: TextStyle(
                  color: Colors.white,
                  // fontFamily: 'Slidefu-Regular-2',
                  fontSize: 22,
                ),
              ),
            ),
          ),
          // ),
        ),
        // === Happy New Year
        // child: HappyCard(
        //   size: const Size(400, 440),
        //   background: scenery,
        // ),
      ),
    );
  }
}
