import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_onnxruntime/flutter_onnxruntime.dart';

import 'non_maximum_suppression.dart';
import 'utils/extension.dart';

class OrtYolo {
  static const inputSize = 640;
  final _completer = Completer<bool>();
  final bool isAndroid;
  late final OrtSession session;

  OrtYolo({required this.isAndroid}) {
    _init();
  }

  void dispose() {
    session.close();
  }

  Future<void> _init() async {
    final onnx = OnnxRuntime();
    try {
      session = await onnx.createSessionFromAsset("assets/models/yolo11n.ort");
      _completer.complete(true);
    } catch (e) {
      _completer.completeError(e);
    } finally {
      _completer.complete(false);
    }
  }

  Future<bool> get isReady => _completer.future;

  Future<List<BoundingBox>> detect(
    ui.Image image, {
    double confThreshold = .25,
    double nmsThreshold = .45,
  }) async {
    if (await isReady == false) {
      debugPrint("Failed to load YOLO model");
      return [];
    }
    final img = await (isAndroid
        ? image.androidResize(inputSize, inputSize)
        : image.resize(inputSize, inputSize));
    final input = await img.toFloat32NCHW();
    final inputOrt = await OrtValue.fromList(input, [
      1,
      3,
      inputSize,
      inputSize,
    ]);

    final outputOrt = await session.run({"images": inputOrt});
    inputOrt.dispose();

    final outTensor = (await outputOrt['output0']?.asList())
        ?.cast<List>() // List<List<List>>
        .map((e) => (e).map((x) => (x as List).cast<double>()).toList())
        .toList();
    for (var element in outputOrt.values) {
      element.dispose();
    }

    var selectedBoxes = <BoundingBox>[];
    if (outTensor?[0] != null) {
      final channels = outTensor![0].transpose();
      outTensor.clear();
      final anchorProbs = channels
          .map((c) => c.skip(4).reduce(math.max))
          .toList();
      final boxes = <BoundingBox>[];
      for (int i = 0; i < anchorProbs.length; i++) {
        final prob = anchorProbs[i];
        final classID =
            channels[i].indexWhere((c) => (c - prob).abs() < 1e-6) - 4;
        final xywh = channels[i].sublist(0, 4);
        final x1 = xywh[0] - xywh[2] / 2;
        final y1 = xywh[1] - xywh[3] / 2;
        final x2 = xywh[0] + xywh[2] / 2;
        final y2 = xywh[1] + xywh[3] / 2;
        boxes.add(
          BoundingBox(
            x1: x1,
            y1: y1,
            x2: x2,
            y2: y2,
            confidence: prob,
            classId: classID,
            index: i,
          ),
        );
      }
      selectedBoxes = nonMaximumSuppress(boxes, confThreshold, nmsThreshold);
    }
    return selectedBoxes;
  }

  Future<List<BoundingBox>> call(
    ui.Image image, {
    double confThreshold = .25,
    double nmsThreshold = .45,
  }) => detect(image, confThreshold: confThreshold, nmsThreshold: nmsThreshold);
}
