import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';

extension YoloList<T> on List<List<T>> {
  List<List<T>> transpose() {
    final rowCount = length;
    final colCount = first.length;
    return List.generate(
      colCount,
      (i) => List.generate(rowCount, (j) => this[j][i]),
    );
  }
}

extension YoloImage on ui.Image {
  Future<ui.Image> resize(int width, int height) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    final srcRect =
        Offset.zero & Size(this.width.toDouble(), this.height.toDouble());
    final dstRect = Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble());

    canvas.drawImageRect(this, srcRect, dstRect, Paint());
    final picture = recorder.endRecording();
    return picture.toImage(width, height);
  }

  Future<ui.Image> androidResize(int width, int height) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // 移动画布原点到中心（旋转围绕中心）
    canvas.translate(width / 2, height / 2);

    // 旋转 90°（顺时针为正，逆时针传负值）
    canvas.rotate(90 * math.pi / 180);

    // 再把坐标系移回去（因为前面移动了中心）
    canvas.translate(-height / 2, -width / 2);

    final srcRect =
        Offset.zero & Size(this.width.toDouble(), this.height.toDouble());
    // 注意：此时宽高对调，因为旋转 90° 后，w/h 会交换
    final dstRect = Rect.fromLTWH(0, 0, height.toDouble(), width.toDouble());

    canvas.drawImageRect(this, srcRect, dstRect, Paint());
    final picture = recorder.endRecording();
    return picture.toImage(width, height);
  }

  Future<Float32List> toFloat32NCHW() async {
    final byteData = await toByteData(format: ui.ImageByteFormat.rawRgba);
    final pixels = byteData!.buffer.asUint8List();

    final int stride = width * height;
    final Float32List input = Float32List(1 * 3 * width * height);
    int pixelIndex = 0;
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final r = pixels[pixelIndex] / 255.0;
        final g = pixels[pixelIndex + 1] / 255.0;
        final b = pixels[pixelIndex + 2] / 255.0;

        final idx = y * width + x;
        input[idx] = r; // Channel 0
        input[stride + idx] = g; // Channel 1
        input[2 * stride + idx] = b; // Channel 2

        pixelIndex += 4;
      }
    }

    return input;
  }
}
