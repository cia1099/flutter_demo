import 'package:flutter/material.dart';

class HeartCurve extends Curve2D {
  final Size size;

  HeartCurve({required this.size});
  @override
  Offset transformInternal(double t) {
    final width = size.width;
    final height = size.height;

    final start = Offset(0.5 * width, height * 0.35);
    final end = Offset(0.5 * width, 0.9 * height);
    final cp1 = Offset(0.2 * width, height * 0.1);
    final cp2 = Offset(-0.25 * width, height * 0.6);
    final cp3 = Offset(1.25 * width, height * 0.6);
    final cp4 = Offset(0.8 * width, height * 0.1);
    late Offset currentPoint;
    if (t < 0.5) {
      currentPoint = _lerpBezier(start, end, cp1, cp2, t * 2);
    } else {
      currentPoint = _lerpBezier(end, start, cp3, cp4, (t - 0.5) * 2);
    }
    return currentPoint;
  }

  Offset _lerpBezier(
      Offset start, Offset end, Offset cp1, Offset cp2, double progress) {
    // retivival current point
    final pPoint1 = Offset.lerp(start, cp1, progress);
    final pPoint2 = Offset.lerp(cp1, cp2, progress);
    final pPoint3 = Offset.lerp(cp2, end, progress);
    final mPoint1 = Offset.lerp(pPoint1, pPoint2, progress);
    final mPoint2 = Offset.lerp(pPoint2, pPoint3, progress);
    return Offset.lerp(mPoint1, mPoint2, progress)!;
  }
}

class HeartPainter extends CustomPainter {
  // The color of the heart
  final Color bodyColor;
  // The color of the border of the heart
  final Color borderColor;
  // The thickness of the border
  final double borderWith;
  final Animation<double>? progress;
  final List<double> _timeLine = [];

  HeartPainter({
    this.progress,
    required this.bodyColor,
    required this.borderColor,
    required this.borderWith,
  }) : super(repaint: progress);

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    Paint paintBorder = Paint();
    paintBorder
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = borderWith;

    Paint paintFill = Paint();
    paintFill
      ..color = bodyColor
      ..style = PaintingStyle.fill
      ..strokeWidth = 0;

    double width = size.width;
    double height = size.height;

    final start = Offset(0.5 * width, height * 0.35);
    final end = Offset(0.5 * width, 0.9 * height);
    final cp1 = Offset(0.2 * width, height * 0.1);
    final cp2 = Offset(-0.25 * width, height * 0.6);
    final cp3 = Offset(1.25 * width, height * 0.6);
    final cp4 = Offset(0.8 * width, height * 0.1);

    final heartCurve = HeartCurve(size: size);
    final current = heartCurve.transform(progress!.value);
    final pointPaint = Paint()..color = Colors.deepOrangeAccent;
    canvas.drawCircle(current, 7, pointPaint);

    if (progress!.isCompleted || progress!.isDismissed) {
      _timeLine.clear();
    } else {
      _timeLine.add(progress!.value);
    }

    if (_timeLine.isEmpty) {
      Path path = Path();
      path.moveTo(start.dx, start.dy);
      path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, end.dx, end.dy);
      path.cubicTo(cp3.dx, cp3.dy, cp4.dx, cp4.dy, start.dx, start.dy);
      canvas.drawPath(path, paintFill);
      canvas.drawPath(path, paintBorder);
    } else {
      canvas.drawPath(tripTimeLine(size, start), paintBorder);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  Path tripTimeLine(Size size, Offset start) {
    var path = Path()..moveTo(start.dx, start.dy);
    final heartCurve = HeartCurve(size: size);
    for (var t in _timeLine) {
      var step = heartCurve.transform(t);
      path.lineTo(step.dx, step.dy);
    }
    return path;
  }
}
