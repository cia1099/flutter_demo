import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';

class YUV2RGBAConverter {
  Uint8List? _rgbaBuffer; // 复用内存避免重复分配

  Future<ui.Image> convert(CameraImage image) async {
    final int width = image.width;
    final int height = image.height;
    final int rgbaSize = width * height * 4;

    // 复用 RGBA 内存以提升性能
    _rgbaBuffer ??= Uint8List(rgbaSize);
    final Uint8List rgba = _rgbaBuffer!;

    if (image.format.group == ImageFormatGroup.yuv420) {
      final Plane planeY = image.planes[0];
      final Plane planeU = image.planes[1];
      final Plane planeV = image.planes[2];

      final int uvRowStride = planeU.bytesPerRow;
      final int uvPixelStride = planeU.bytesPerPixel!;

      int index = 0;
      for (int y = 0; y < height; y++) {
        final int uvRow = uvRowStride * (y >> 1);
        final int yRow = planeY.bytesPerRow * y;

        for (int x = 0; x < width; x++) {
          final int uvIndex = uvRow + (x >> 1) * uvPixelStride;

          final int Y = planeY.bytes[yRow + x];
          final int U = planeU.bytes[uvIndex];
          final int V = planeV.bytes[uvIndex];

          int R = (Y + (1.403 * (V - 128))).toInt();
          int G = (Y - (0.344 * (U - 128)) - (0.714 * (V - 128))).toInt();
          int B = (Y + (1.770 * (U - 128))).toInt();

          rgba[index++] = R.clamp(0, 255);
          rgba[index++] = G.clamp(0, 255);
          rgba[index++] = B.clamp(0, 255);
          rgba[index++] = 255; // A
        }
      }
    } else if (image.format.group == ImageFormatGroup.nv21) {
      final Plane planeY = image.planes[0];
      final Plane planeUV = image.planes[1];
      final int uvRowStride = planeUV.bytesPerRow;
      final int uvPixelStride = planeUV.bytesPerPixel!; // usually 2: CbCr
      int index = 0;
      for (int y = 0; y < height; y++) {
        final int yRow = planeY.bytesPerRow * y;
        final int uvRow = uvRowStride * (y >> 1);
        for (int x = 0; x < width; x++) {
          final int uvIndex = uvRow + (x >> 1) * uvPixelStride;
          final int Y = planeY.bytes[yRow + x];
          final int U = planeUV.bytes[uvIndex]; // Cb
          final int V = planeUV.bytes[uvIndex + 1]; // Cr
          int R = (Y + 1.403 * (V - 128)).toInt();
          int G = (Y - 0.344 * (U - 128) - 0.714 * (V - 128)).toInt();
          int B = (Y + 1.770 * (U - 128)).toInt();
          rgba[index++] = R.clamp(0, 255);
          rgba[index++] = G.clamp(0, 255);
          rgba[index++] = B.clamp(0, 255);
          rgba[index++] = 255;
        }
      }
    } else if (image.format.group == ImageFormatGroup.bgra8888) {
      // Plane bytes format: B G R A
      final Uint8List bytes = image.planes[0].bytes;
      int index = 0;
      for (int i = 0; i < bytes.length; i += 4) {
        rgba[index++] = bytes[i + 2]; // R
        rgba[index++] = bytes[i + 1]; // G
        rgba[index++] = bytes[i]; // B
        rgba[index++] = bytes[i + 3]; // A
      }
    } else {
      throw UnsupportedError(
        'Unsupported camera format: ${image.format.group}',
      );
    }

    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromPixels(
      rgba,
      width,
      height,
      ui.PixelFormat.rgba8888,
      (ui.Image img) => completer.complete(img),
    );

    return completer.future;
  }
}
