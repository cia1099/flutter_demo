import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bezier Curves',
      home: Scaffold(
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Bezier Curve',
                    style: Theme.of(context).textTheme.headline4),
              ),
              const Text('Drag the grey handles to change the curve'),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: BezierWidget(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BezierWidget extends StatefulWidget {
  const BezierWidget({
    Key? key,
  }) : super(key: key);

  @override
  _BezierWidgetState createState() => _BezierWidgetState();
}

class ControlPointDetails {
  ControlPointDetails(this.point) : isTouched = false;

  Offset point;
  bool isTouched;

  void determineTouchYes(Offset touchPoint) {
    if ((touchPoint.distanceSquared - point.distanceSquared).abs() < 5000) {
      isTouched = true;
    } else {
      isTouched = false;
    }
  }
}

class _BezierWidgetState extends State<BezierWidget>
    with SingleTickerProviderStateMixin {
  ControlPointDetails? cpo1;
  ControlPointDetails? cpo2;

  double _sliderValue = 0.5;

  late AnimationController _animationController;

  @override
  void initState() {
    WidgetsBinding.instance!
        .addPostFrameCallback((_) => _postFrameCallback(context));
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _animationController.addListener(_animationListener);
    super.initState();
  }

  void _postFrameCallback(BuildContext context) {
    _refresh();
  }

  void _onTapDown(DragStartDetails details) {
    cpo1?.determineTouchYes(details.localPosition);
    cpo2?.determineTouchYes(details.localPosition);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (cpo1?.isTouched ?? false) {
      setState(() {
        cpo1!.point = details.localPosition;
      });
    }
    if (cpo2?.isTouched ?? false) {
      setState(() {
        cpo2!.point = details.localPosition;
      });
    }
  }

  void _onPanEnd(DragEndDetails details) {
    cpo1?.isTouched = false;
    cpo2?.isTouched = false;
  }

  void _refresh() {
    setState(() {
      cpo1 = ControlPointDetails(Offset(context.size!.width / 3, 50));
      cpo2 = ControlPointDetails(Offset(context.size!.width / 3 * 2, 50));
    });
  }

  void _sliderChange(double value) {
    setState(() {
      _sliderValue = value;
    });
  }

  void _playAnimation() {
    _animationController.forward(from: 0);
  }

  void _animationListener() {
    _sliderChange(_animationController.value);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: _onPanUpdate,
      onPanStart: _onTapDown,
      onPanEnd: _onPanEnd,
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                child: CustomPaint(
                  painter: BezierPainter(
                    controlPoint1: cpo1?.point,
                    controlPoint2: cpo2?.point,
                    progress: _sliderValue,
                  ),
                  child: Container(),
                ),
              ),
              Slider(
                value: _sliderValue,
                onChanged: _sliderChange,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Progress: ${_sliderValue.toStringAsFixed(2)}'),
                    Text('Control Point 1: ${cpo1?.point}'),
                    Text('Control Point 2: ${cpo2?.point}'),
                  ],
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton(
              onPressed: _playAnimation,
              child: const Icon(Icons.play_arrow),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              onPressed: _refresh,
              child: const Icon(Icons.refresh),
            ),
          ),
        ],
      ),
    );
  }
}

class BezierPainter extends CustomPainter {
  BezierPainter({
    this.controlPoint1,
    this.controlPoint2,
    this.progress = 0.5,
  });
  final Offset? controlPoint1;
  final Offset? controlPoint2;

  final double progress;

  static final curvePaint = Paint()
    ..color = Colors.black
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 5;
  static final greyLinePaint = Paint()
    ..color = Colors.grey
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;
  static final redLinePaint = Paint()
    ..color = Colors.red
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;
  static final greenLinePaint = Paint()
    ..color = Colors.green
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;
  static final pointPaint = Paint()..color = Colors.deepOrangeAccent;

  @override
  void paint(Canvas canvas, Size size) {
    final point1 = Offset(0, size.height / 2);
    final point2 = Offset(size.width, size.height / 2);
    final cp1 = controlPoint1 ?? Offset(size.width / 2, 0);
    final cp2 = controlPoint2 ?? Offset(size.width / 2, size.height);

    final path = Path()
      ..moveTo(point1.dx, point1.dy)
      ..cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, point2.dx, point2.dy);

    canvas
      ..drawPath(
        path,
        curvePaint,
      )
      ..drawLine(point1, cp1, greyLinePaint)
      ..drawLine(cp1, cp2, greyLinePaint)
      ..drawLine(cp2, point2, greyLinePaint)
      ..drawCircle(cp1, 7, greyLinePaint)
      ..drawCircle(cp2, 7, greyLinePaint);

    final pPoint1 = Offset.lerp(point1, cp1, progress);
    final pPoint2 = Offset.lerp(cp1, cp2, progress);
    final pPoint3 = Offset.lerp(cp2, point2, progress);

    canvas
      ..drawCircle(pPoint1!, 4, redLinePaint)
      ..drawCircle(pPoint2!, 4, redLinePaint)
      ..drawLine(pPoint1, pPoint2, redLinePaint)
      ..drawCircle(pPoint3!, 4, redLinePaint)
      ..drawLine(pPoint2, pPoint3, redLinePaint);

    final mPoint1 = Offset.lerp(pPoint1, pPoint2, progress);
    final mPoint2 = Offset.lerp(pPoint2, pPoint3, progress);

    canvas
      ..drawCircle(mPoint1!, 3, greenLinePaint)
      ..drawCircle(mPoint2!, 3, greenLinePaint)
      ..drawLine(mPoint1, mPoint2, greenLinePaint)
      ..drawCircle(Offset.lerp(mPoint1, mPoint2, progress)!, 7, pointPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
