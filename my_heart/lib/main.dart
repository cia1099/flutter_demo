import 'dart:ui' as ui show Image, Gradient;

import 'package:flutter/material.dart';
import 'package:my_heart/heart.dart';
import 'package:my_heart/node/fireworks_node.dart';
import 'package:my_heart/utilts.dart';
import 'package:scratcher/scratcher.dart';
import 'package:spritewidget/spritewidget.dart';

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
      ),
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
        // child: CustomPaint(
        //   foregroundPainter: HeartPainter(
        //     bodyColor: Theme.of(context).scaffoldBackgroundColor,
        //     isShallow: true,
        //   ),
        //   child: Scratcher(
        //     brushSize: 30,
        //     threshold: 50,
        //     color: Colors.grey,
        //     rebuildOnResize: false,
        //     onChange: (value) => print("Scratch progress: $value%"),
        //     onThreshold: () => print("Threshold reached, you won!"),
        //     child: Container(
        //       height: 800,
        //       width: 880,
        //       decoration: BoxDecoration(
        //           image: DecorationImage(
        //               image: NetworkImage("https://picsum.photos/300/300"),
        //               fit: BoxFit.cover)),
        //     ),
        //   ),
        // ),
        // === Happy New Year
        child: Container(
          width: 400,
          height: 480,
          child: FutureBuilder<ui.Image>(
            future: dartDecodeImage("assets/firework-particle.png", context),
            builder: (context, snapshot) {
              return Stack(
                children: [
                  scenery,
                  ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (bounds) => ui.Gradient.linear(
                        Offset(bounds.width / 2, bounds.height / 4),
                        Offset(bounds.width / 2, bounds.height / 4 + 30 * 4),
                        [Color(0xFFF0E68C), Colors.red]),
                    child: CustomPaint(
                      painter: HappyNewYearPainter(),
                      size: Size(400, 480),
                    ),
                  ),
                  ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (bounds) => ui.Gradient.linear(
                        Offset(bounds.width / 2, bounds.height / 8 * 5),
                        Offset(bounds.width / 2, bounds.height),
                        [Colors.red, Color(0xFFF0E68C)]),
                    child: CustomPaint(
                      painter: UmbrallaPainter(),
                      size: Size(400, 480),
                    ),
                  ),
                  snapshot.connectionState == ConnectionState.waiting
                      ? const CircularProgressIndicator.adaptive()
                      : LayoutBuilder(
                          builder: (context, constraints) {
                            final parentSize = Size(
                                constraints.maxWidth, constraints.maxHeight);
                            return SpriteWidget(
                              FireworksNode(
                                  image: snapshot.data!,
                                  resolution: parentSize),
                            );
                          },
                        )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class HappyNewYearPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const fontSize = 30.0;
    final textStyle = TextStyle(
        color: Colors.white,
        fontSize: fontSize,
        fontFamily: 'Slidefu-Regular-2');
    String chinese = "新年快乐";
    for (int i = 0; i < chinese.length; i++) {
      var c = chinese[i];
      final textSpan = TextSpan(text: c, style: textStyle);
      final textPainter =
          TextPainter(text: textSpan, textDirection: TextDirection.ltr)
            ..layout(
              minWidth: 0,
              maxWidth: size.width,
            );
      final x = (size.width - textPainter.width) / 2;
      final y = size.height / 4 - textPainter.height / 2 + fontSize * i;
      textPainter.paint(canvas, Offset(x, y));
    }
    final textSpan = TextSpan(
      text: '2023',
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    )..layout(
        minWidth: 0,
        maxWidth: size.width,
      );
    final xCenter = (size.width - textPainter.width) / 2;
    final yCenter = size.height / 4 + fontSize * chinese.length;
    final offset = Offset(xCenter, yCenter);
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class UmbrallaPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const fontSize = 30.0;
    final textStyle = TextStyle(
        color: Colors.white,
        fontSize: fontSize,
        fontFamily: 'Slidefu-Regular-2');
    final top = Offset(size.width / 2, size.height / 8 * 5);
    final umbralla = Path()..moveTo(top.dx, top.dy);
    final WUmbralla = fontSize * 5 / 3;
    final hUmbralla = 3 * WUmbralla;
    umbralla.lineTo(top.dx + WUmbralla, top.dy + hUmbralla / 4);
    umbralla.lineTo(top.dx - WUmbralla, top.dy + hUmbralla / 4);
    umbralla.lineTo(top.dx - WUmbralla / 4, top.dy + hUmbralla / 8);
    umbralla.moveTo(top.dx, top.dy);
    umbralla.lineTo(top.dx, top.dy + hUmbralla);
    canvas.drawPath(
        umbralla,
        Paint()
          ..color = Colors.white
          ..strokeWidth = 5
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round);
    //----names
    final lb = Offset(top.dx - fontSize, top.dy + hUmbralla * 0.85);
    var lName = '善弘林';
    for (int i = 0; i < lName.length; i++) {
      var c = lName[i];
      final textSpan = TextSpan(text: c, style: textStyle);
      final textPainter =
          TextPainter(text: textSpan, textDirection: TextDirection.ltr)
            ..layout(
              minWidth: 0,
              maxWidth: size.width,
            );
      final x = lb.dx - textPainter.width / 2;
      final y = lb.dy - textPainter.height / 2 - fontSize * i;
      textPainter.paint(canvas, Offset(x, y));
    }
    final rb = Offset(top.dx + fontSize, top.dy + hUmbralla * 0.85);
    var rName = '雪万';
    for (int i = 0; i < rName.length; i++) {
      var c = rName[i];
      final textSpan = TextSpan(text: c, style: textStyle);
      final textPainter =
          TextPainter(text: textSpan, textDirection: TextDirection.ltr)
            ..layout(
              minWidth: 0,
              maxWidth: size.width,
            );
      final x = rb.dx - textPainter.width / 2;
      final y = rb.dy - textPainter.height / 2 - fontSize * i;
      textPainter.paint(canvas, Offset(x, y));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
