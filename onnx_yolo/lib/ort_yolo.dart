import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_onnxruntime/flutter_onnxruntime.dart';

import 'non_maximum_suppression.dart' as nms;
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
      final options = OrtSessionOptions(
        // providers: [OrtProvider.NNAPI],
        // intraOpNumThreads: 0,
        // interOpNumThreads: 0,
        providers: [OrtProvider.CORE_ML],
        useArena: true,
      );
      session = await onnx.createSessionFromAsset(
        "assets/models/yolo11n.ort",
        options: options,
      );
      _completer.complete(true);
    } catch (e) {
      _completer.complete(false);
      _completer.completeError(e);
    }
  }

  Future<bool> get isReady => _completer.future;

  Future<List<nms.BoundingBox>> detect(
    ui.Image image, {
    double confThreshold = .25,
    double nmsThreshold = .45,
  }) async {
    if (await isReady == false) {
      debugPrint("Failed to load YOLO model");
      return [];
    }
    final sw = Stopwatch()..start();
    final img = await (isAndroid
        ? image.androidResize(inputSize, inputSize)
        : image.resize(inputSize, inputSize));
    final input = await img.toFloat32NCHW();
    final preProcess = (sw..stop()).elapsedMilliseconds;

    final inputOrt = await OrtValue.fromList(input, [
      1,
      3,
      inputSize,
      inputSize,
    ]);

    (sw..reset()).start();
    final outputOrt = await session.run({"images": inputOrt});
    inputOrt.dispose();
    final predTime = (sw..stop()).elapsedMilliseconds;

    final outTensor = (await outputOrt['output0']?.asList())
        ?.cast<List>() // List<List<List>>
        .map((e) => (e).map((x) => (x as List).cast<double>()).toList())
        .toList();
    for (var element in outputOrt.values) {
      element.dispose();
    }

    // MARK: - Mock Yolo output
    (sw..reset()).start();
    if (outTensor == null) {
      return [];
    }
    final selectedBoxes = nonMaximumSuppress(
      outTensor,
      confThreshold,
      nmsThreshold,
    );
    final postProcess = (sw..stop()).elapsedMilliseconds;
    debugPrint(
      "Elapsed time - preprocess:${preProcess}ms, inference:${predTime}ms, postprocess:${postProcess}ms",
    );
    return selectedBoxes;
  }

  Future<List<nms.BoundingBox>> call(
    ui.Image image, {
    double confThreshold = .25,
    double nmsThreshold = .45,
  }) => detect(image, confThreshold: confThreshold, nmsThreshold: nmsThreshold);

  List<nms.BoundingBox> nonMaximumSuppress(
    List<List<List<double>>> outTensor,
    double confThreshold,
    double nmsThreshold,
  ) {
    var selectedBoxes = <nms.BoundingBox>[];
    // if (outTensor?[0] != null) {
    final channels = outTensor[0].transpose();
    outTensor.clear();
    final anchorProbs = channels
        .map((c) => c.skip(4).reduce(math.max))
        .toList();
    final boxes = <nms.BoundingBox>[];
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
        nms.BoundingBox(
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
    selectedBoxes = nms.nonMaximumSuppress(boxes, confThreshold, nmsThreshold);
    // }
    return selectedBoxes;
  }
}
