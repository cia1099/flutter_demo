import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onnx_yolo/ort_yolo.dart';

import 'frosted_button.dart';
import 'non_maximum_suppression.dart';
import 'utils/constants.dart';
import 'utils/yuv2rgba_converter.dart';

class DetectPage extends StatefulWidget {
  final CameraDescription camera;

  const DetectPage({super.key, required this.camera});

  @override
  State<DetectPage> createState() => _DetectPageState();
}

class _DetectPageState extends State<DetectPage> {
  late final ortYolo = OrtYolo(
    isAndroid: Theme.of(context).platform == TargetPlatform.android,
  );
  final boxes = PaintingBoxes();
  late final controller = CameraController(
    widget.camera,
    ResolutionPreset.medium,
  );
  late final isReady = controller.initialize().then((_) async {
    if (!(await ortYolo.isReady)) {
      throw Exception("Failed to load YOLO model");
    }

    controller.startImageStream((cameraImage) async {
      final frame = await converter.convert(cameraImage);
      streamController.add(frame);
      if (isDetect) {
        boxes << await ortYolo(frame);
      } else if (boxes.isNotEmpty) {
        boxes << [];
      }
    });
  });
  final streamController = StreamController<ui.Image>();
  final converter = YUV2RGBAConverter();
  var isDetect = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isAndroid = Theme.of(context).platform == TargetPlatform.android;
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text("Detecting Object")),
      child: SafeArea(
        top: false,
        child: FutureBuilder(
          future: isReady,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CupertinoActivityIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  snapshot.error.toString(),
                  style: TextStyle(color: colorScheme.error),
                ),
              );
            }
            // return controller.buildPreview();
            return Stack(
              children: [
                StreamBuilder(
                  stream: streamController.stream,
                  builder: (context, snapshot) {
                    if (snapshot.data == null) {
                      return const Center(child: CupertinoActivityIndicator());
                    }
                    return RepaintBoundary(
                      child: CustomPaint(
                        painter: CameraPainter(
                          frame: snapshot.data!,
                          camera: widget.camera,
                          isAndroid: isAndroid,
                        ),
                        child: RepaintBoundary(
                          child: CustomPaint(
                            painter: BoxesPainter(boxes: boxes),
                            size: Size.infinite,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Align(
                  alignment: Alignment(0, .9),
                  child: FrostedButton(
                    onPressed: () => setState(() {
                      isDetect ^= true;
                    }),
                    icon: isDetect ? CupertinoIcons.stop : CupertinoIcons.play,
                    iconColor: isDetect
                        ? CupertinoColors.systemRed.resolveFrom(context)
                        : null,
                    size: 100,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.stopImageStream().whenComplete(() {
      controller.dispose();
    });
    ortYolo.dispose();
    streamController.close();
    super.dispose();
  }
}

// MARK: CameraPainter
class CameraPainter extends CustomPainter {
  final ui.Image frame;
  final CameraDescription camera;
  final bool isAndroid;

  CameraPainter({
    required this.frame,
    required this.camera,
    required this.isAndroid,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();

    if (isAndroid) {
      // 移动画布原点到中心（旋转围绕中心）
      canvas.translate(size.width / 2, size.height / 2);

      // 旋转 90°（顺时针为正，逆时针传负值）
      canvas.rotate(camera.sensorOrientation * math.pi / 180);

      // 再把坐标系移回去（因为前面移动了中心）
      canvas.translate(-size.height / 2, -size.width / 2);
    }

    final srcRect = Rect.fromLTWH(
      0,
      0,
      frame.width.toDouble(),
      frame.height.toDouble(),
    );

    // 注意：此时宽高对调，因为旋转 90° 后，w/h 会交换
    final dstRect = Rect.fromLTWH(
      0,
      0,
      isAndroid ? size.height : size.width, // <— 旋转后宽高互换
      isAndroid ? size.width : size.height,
    );

    canvas.drawImageRect(frame, srcRect, dstRect, Paint());

    canvas.restore();
  }

  // @override
  // void paint(Canvas canvas, Size size) {
  //   final srcRect = Rect.fromLTWH(
  //     0,
  //     0,
  //     frame.width.toDouble(),
  //     frame.height.toDouble(),
  //   );
  //   final dstRect = Offset.zero & size;
  //   canvas.drawImageRect(frame, srcRect, dstRect, Paint());
  // }

  @override
  bool shouldRepaint(covariant CameraPainter oldDelegate) =>
      frame != oldDelegate.frame;
}

// MARK: - BoxesPainter
class BoxesPainter extends CustomPainter {
  final PaintingBoxes? boxes;

  BoxesPainter({this.boxes}) : super(repaint: boxes);

  @override
  void paint(Canvas canvas, Size size) {
    if (boxes == null || boxes!.isEmpty) return;
    final scaleX = size.width / OrtYolo.inputSize;
    final scaleY = size.height / OrtYolo.inputSize;
    for (final box in boxes!) {
      final rect = Rect.fromLTRB(
        box.x1 * scaleX,
        box.y1 * scaleY,
        box.x2 * scaleX,
        box.y2 * scaleY,
      );
      canvas.drawRect(
        rect,
        Paint()
          ..color = Colors.green
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5,
      );
      final textPainter = TextPainter(
        text: TextSpan(
          text:
              "${kCocoClasses[box.classId]}: ${box.confidence.toStringAsFixed(2)}",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(canvas, rect.topLeft - Offset(0, textPainter.height));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
