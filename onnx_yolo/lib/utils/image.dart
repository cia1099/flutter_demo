import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

Future<ui.Image> dartDecodeImage(String path, [BuildContext? context]) async {
  /**
   * ref. https://stackoverflow.com/questions/65439889/flutter-canvas-drawimage-draws-a-pixelated-image
   * ref. https://blog.csdn.net/jia635/article/details/108155213
   */
  ImageStream imgStream;
  if (path.substring(0, 4) == 'http') {
    imgStream = NetworkImage(path).resolve(
      context == null
          ? ImageConfiguration.empty
          : createLocalImageConfiguration(context),
    );
  } else {
    imgStream = AssetImage(path).resolve(
      context == null
          ? ImageConfiguration.empty
          : createLocalImageConfiguration(context),
    );
  }
  final completer = Completer<ui.Image>();
  imgStream.addListener(
    ImageStreamListener((image, synchronousCall) {
      completer.complete(image.image);
    }),
  );
  return completer.future;
}
