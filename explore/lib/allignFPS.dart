import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Animation Course',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Explicit Animations'),
        ),
        body: const Center(
          child: AnimatedBuilderExample(),
        ),
      ),
    );
  }
}

class AnimatedBuilderExample extends StatefulWidget {
  const AnimatedBuilderExample({Key? key}) : super(key: key);

  @override
  _AnimatedBuilderExampleState createState() => _AnimatedBuilderExampleState();
}

class _AnimatedBuilderExampleState extends State<AnimatedBuilderExample>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _meanFPS = 0;
  double _sumTime = 0;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        _sumTime = 0;
      } else if (status == AnimationStatus.completed) {
        _meanFPS = 1e6 / _sumTime;
        _controller.reset();
        _controller.forward();
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tic = Stopwatch()..start();
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        tic.reset();
        final animate = Transform.rotate(
          angle: _controller.value * 2 * pi,
          child: child,
        );
        tic.stop();
        _sumTime += tic.elapsedMicroseconds.toDouble();
        tic.start();
        final widget = Stack(
          children: [
            Align(
              alignment: FractionalOffset(0.1, 0.05),
              child: Text("Mean FPS =" + _meanFPS.toStringAsFixed(0),
                  style: TextStyle(fontSize: 20)),
            ),
            Align(
              alignment: FractionalOffset(0.5, 0.5),
              child: animate,
            ),
          ],
        );
        return widget;
      },
      child: Container(color: Colors.red, width: 100, height: 100),
    );
  }
}

// class _AnimatedBuilderExampleState extends State<AnimatedBuilderExample>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   double _meanFPS = 0;
//   double _sumTime = 0;
//   late Stopwatch tic;

//   @override
//   void initState() {
//     _controller =
//         AnimationController(vsync: this, duration: Duration(seconds: 1));
//     _controller.addListener(() {
//       setState(() => null);
//     });
//     _controller.addStatusListener((status) {
//       if (status == AnimationStatus.forward) {
//         _sumTime = 0;
//       } else if (status == AnimationStatus.completed) {
//         _meanFPS = 1e6 / _sumTime;
//         _controller.reset();
//         _controller.forward();
//       }
//     });
//     _controller.forward();
//     tic = Stopwatch()..start();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     tic.reset();
//     final widget = Stack(
//       children: [
//         Align(
//           alignment: FractionalOffset(0.1, 0.05),
//           child: Text(
//             "mean FPS = " + _meanFPS.toStringAsFixed(0),
//             style: TextStyle(fontSize: 20),
//           ),
//         ),
//         Align(
//           alignment: FractionalOffset(0.5, 0.5),
//           child: Transform.rotate(
//             angle: _controller.value * 2 * pi,
//             child: Container(color: Colors.red, width: 100, height: 100),
//           ),
//         ),
//       ],
//     );
//     tic.stop();
//     _sumTime += tic.elapsedMicroseconds.toDouble();
//     tic.start();
//     return widget;
//   }
// }
