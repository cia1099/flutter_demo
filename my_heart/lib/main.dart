import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_heart/heart.dart';

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
      body: const Center(
        // child: CustomPaint(
        //   size: Size(880, 800),
        //   painter: HeartPainter(
        //     bodyColor: Color(0xFFF27788),
        //     borderColor: Color.fromARGB(255, 41, 17, 9),
        //     borderWith: 12,
        //   ),
        // ),
        child:
            AnimationDemo(duration: Duration(seconds: 3), size: Size(880, 800)),
      ),
    );
  }
}

class AnimationDemo extends StatefulWidget {
  final Duration duration;
  final Size size;
  const AnimationDemo({
    Key? key,
    required this.duration,
    required this.size,
  }) : super(key: key);

  @override
  State<AnimationDemo> createState() => _AnimationDemoState();
}

class _AnimationDemoState extends State<AnimationDemo>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Timer(widget.duration, () => _animationController.reverse());
      }
      if (status == AnimationStatus.dismissed) {
        Timer(widget.duration, () => _animationController.forward());
      }
    });
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: HeartPainter(
        progress: _animationController,
        bodyColor: Color(0xFFF27788),
        borderColor: Color.fromARGB(255, 41, 17, 9),
        borderWith: 12,
      ),
      size: widget.size,
    );
  }
}
