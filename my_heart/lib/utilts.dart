import 'dart:async';
import 'dart:ui' as ui show Image;

import 'package:flutter/material.dart';
import 'package:my_heart/heart.dart';

Future<ui.Image> dartDecodeImage(String path, [BuildContext? context]) async {
  /// ref. https://stackoverflow.com/questions/65439889/flutter-canvas-drawimage-draws-a-pixelated-image
  /// ref. https://blog.csdn.net/jia635/article/details/108155213
  ImageStream imgStream;
  if (path.substring(0, 4) == 'http') {
    imgStream = NetworkImage(path).resolve(context == null
        ? ImageConfiguration.empty
        : createLocalImageConfiguration(context));
  } else {
    imgStream = AssetImage(path).resolve(context == null
        ? ImageConfiguration.empty
        : createLocalImageConfiguration(context));
  }
  final completer = Completer<ui.Image>();
  imgStream.addListener(ImageStreamListener(
    (image, synchronousCall) {
      completer.complete(image.image);
    },
  ));
  return completer.future;
}

Path heartGraph(Size size) {
  double width = size.width;
  double height = size.height;
  final start = Offset(0.5 * width, height * 0.35);
  var path = Path()..moveTo(start.dx, start.dy);
  final heartCurve = HeartCurve(size: size);
  for (var t = 0.01; t <= 1.0; t += 0.01) {
    var step = heartCurve.transform(t);
    path.lineTo(step.dx, step.dy);
  }
  return path; //.shift(Offset(-width / 2, -height / 2));
}

class ImagePaiter extends CustomPainter {
  final ui.Image image;
  Color? wallColor;

  ImagePaiter({required this.image, this.wallColor});

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
