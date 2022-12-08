import 'dart:async';

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

class HeartAnimation extends StatefulWidget {
  final Duration duration;
  final Size size;
  // The color of the heart
  final Color bodyColor;
  // The color of the border of the heart
  final Color borderColor;
  // The thickness of the border
  final double borderWith;
  const HeartAnimation({
    Key? key,
    required this.duration,
    required this.size,
    required this.bodyColor,
    required this.borderColor,
    required this.borderWith,
  }) : super(key: key);

  @override
  State<HeartAnimation> createState() => _HeartAnimationState();
}

class _HeartAnimationState extends State<HeartAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
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
        bodyColor: widget.bodyColor,
        borderColor: widget.borderColor,
        borderWith: widget.borderWith,
      ),
      size: widget.size,
    );
  }
}

class HeartPainter extends CustomPainter {
  // The color of the heart
  final Color bodyColor;
  // The color of the border of the heart
  final Color? borderColor;
  // The thickness of the border
  final double? borderWith;
  final bool isShallow;
  final Animation<double>? progress;
  final List<double> _timeLine = [];

  HeartPainter({
    required this.bodyColor,
    this.isShallow = false,
    this.progress,
    this.borderColor,
    this.borderWith,
  }) : super(repaint: progress);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paintBorder = Paint();
    paintBorder
      ..color = borderColor ?? Colors.transparent
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = borderWith ?? 0.0;

    Paint paintFill = Paint();
    paintFill
      ..color = bodyColor
      ..style = PaintingStyle.fill
      ..strokeWidth = 0;

    double width = size.width;
    double height = size.height;

    final start = Offset(0.5 * width, height * 0.35);

    if (progress != null) {
      if (progress!.status == AnimationStatus.forward) {
        _timeLine.add(progress!.value);
        canvas.drawPath(tripTimeLine(size, start), paintBorder);
      } else if (progress!.status == AnimationStatus.reverse) {
        canvas.drawPath(tripTimeLine(size, start), paintFill);
        canvas.drawPath(tripTimeLine(size, start), paintBorder);
        if (_timeLine.isNotEmpty) _timeLine.removeLast();
      } else if (_timeLine.length > 1) {
        canvas.drawPath(tripTimeLine(size, start), paintFill);
        canvas.drawPath(tripTimeLine(size, start), paintBorder);
      }

      if (!progress!.isCompleted && !progress!.isDismissed) {
        final heartCurve = HeartCurve(size: size);
        final current = heartCurve.transform(progress!.value);
        final pointPaint = Paint()..color = Colors.deepOrangeAccent;
        canvas.drawCircle(current, 7, pointPaint);
      }
    } else {
      var heartPattern = Path()..moveTo(start.dx, start.dy);
      final heartCurve = HeartCurve(size: size);
      for (var t = 0.01; t <= 1.0; t += 0.01) {
        var step = heartCurve.transform(t);
        heartPattern.lineTo(step.dx, step.dy);
      }
      if (isShallow) {
        //ref. https://stackoverflow.com/questions/59626727/how-to-erase-clip-from-canvas-custompaint
        canvas.saveLayer(Rect.largest, Paint());
        canvas.drawRect(Rect.largest, paintFill);
        canvas.drawPath(heartPattern, Paint()..blendMode = BlendMode.clear);
        canvas.restore();
      } else {
        canvas.drawPath(heartPattern, paintFill);
        canvas.drawPath(heartPattern, paintBorder);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

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
