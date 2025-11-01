import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';

class BoundingBox {
  final double x1, y1, x2, y2;
  final double confidence;
  final int classId;
  final int index; // original index

  BoundingBox({
    required this.x1,
    required this.y1,
    required this.x2,
    required this.y2,
    required this.confidence,
    required this.classId,
    required this.index,
  });

  @override
  String toString() {
    return 'BoundingBox(x1: $x1, y1: $y1, x2: $x2, y2: $y2, confidence: $confidence, classId: $classId, index: $index)';
  }
}

/// Calculates the Intersection over Union (IoU) of two bounding boxes.
double iou(BoundingBox box1, BoundingBox box2) {
  final xA = max(box1.x1, box2.x1);
  final yA = max(box1.y1, box2.y1);
  final xB = min(box1.x2, box2.x2);
  final yB = min(box1.y2, box2.y2);

  final interArea = max(0.0, xB - xA) * max(0.0, yB - yA);
  final box1Area = (box1.x2 - box1.x1) * (box1.y2 - box1.y1);
  final box2Area = (box2.x2 - box2.x1) * (box2.y2 - box2.y1);

  final iou = interArea / (box1Area + box2Area - interArea);
  return iou;
}

/// Performs Non-Maximum Suppression (NMS) on a list of bounding boxes.
///
/// This function first filters the boxes by a confidence threshold, then
/// performs NMS on the remaining boxes.
///
/// Args:
///   allBoxes: A list of [BoundingBox] objects. The list should contain all
///          candidate boxes before any confidence filtering.
///   confThreshold: The confidence threshold for filtering boxes.
///   nmsThreshold: The Non-Maximum Suppression threshold for IoU.
///
/// Returns:
///   A list of the selected bounding boxes.
List<BoundingBox> nonMaximumSuppress(
  List<BoundingBox> allBoxes,
  double confThreshold,
  double nmsThreshold,
) {
  // 1. Filter boxes by confidence threshold.
  final confidentBoxes = allBoxes
      .where((box) => box.confidence >= confThreshold)
      .toList();

  if (confidentBoxes.isEmpty) {
    return [];
  }

  // 2. Sort boxes by confidence in descending order.
  confidentBoxes.sort((a, b) => b.confidence.compareTo(a.confidence));

  final selectedBoxes = <BoundingBox>[];
  final suppressed = List<bool>.filled(confidentBoxes.length, false);

  for (int i = 0; i < confidentBoxes.length; i++) {
    if (suppressed[i]) {
      continue;
    }

    selectedBoxes.add(confidentBoxes[i]);

    for (int j = i + 1; j < confidentBoxes.length; j++) {
      if (suppressed[j]) {
        continue;
      }

      final iouValue = iou(confidentBoxes[i], confidentBoxes[j]);
      if (iouValue > nmsThreshold) {
        suppressed[j] = true;
      }
    }
  }

  return selectedBoxes;
}

class PaintingBoxes with ChangeNotifier, IterableMixin<BoundingBox> {
  List<BoundingBox> boxes = [];

  void setBoxes(List<BoundingBox> newBoxes) {
    boxes = newBoxes;
    notifyListeners();
  }

  @override
  int get length => boxes.length;
  @override
  bool get isEmpty => boxes.isEmpty;
  BoundingBox operator [](int index) => boxes[index];
  void operator <<(List<BoundingBox> newBoxes) => setBoxes(newBoxes);
  @override
  Iterator<BoundingBox> get iterator => boxes.iterator;
}

// Example Usage:
void main() {
  // Create a list of all boxes with original indices
  final allBoxes = [
    BoundingBox(
      x1: 10,
      y1: 10,
      x2: 50,
      y2: 50,
      confidence: 0.9,
      classId: 0,
      index: 0,
    ),
    BoundingBox(
      x1: 12,
      y1: 12,
      x2: 52,
      y2: 52,
      confidence: 0.85,
      classId: 0,
      index: 1,
    ),
    BoundingBox(
      x1: 100,
      y1: 100,
      x2: 150,
      y2: 150,
      confidence: 0.95,
      classId: 1,
      index: 2,
    ),
    BoundingBox(
      x1: 105,
      y1: 105,
      x2: 155,
      y2: 155,
      confidence: 0.7,
      classId: 1,
      index: 3,
    ),
    BoundingBox(
      x1: 200,
      y1: 200,
      x2: 250,
      y2: 250,
      confidence: 0.6,
      classId: 2,
      index: 4,
    ),
    BoundingBox(
      x1: 300,
      y1: 300,
      x2: 350,
      y2: 350,
      confidence: 0.1,
      classId: 3,
      index: 5,
    ), // This one should be filtered out
  ];

  const confThreshold = 0.25;
  const nmsThreshold = 0.45;

  final selectedBoxes = nonMaximumSuppress(
    allBoxes,
    confThreshold,
    nmsThreshold,
  );

  print(
    'Selected original indices: ${selectedBoxes.map((b) => b.index)}',
  ); // Expected: [2, 0, 4]

  // final selectedBoxes = selectedIndices.map((i) => allBoxes[i]).toList();
  print('Selected boxes:');
  for (final box in selectedBoxes) {
    print(box);
  }
}
