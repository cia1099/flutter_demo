import 'package:flutter/material.dart';
import 'package:my_heart/heart.dart';
import 'package:my_heart/utilts.dart';
import 'package:spritewidget/spritewidget.dart';

class HeartLightNode extends NodeWithSize {
  // failure draw heart
  Animation<double> progress;
  final Size resolution;
  late HeartCurve _heartCurve;
  late List<double> _timeLine;
  late final EffectLine _effectLine;
  late final EffectLine _spotEffect;

  HeartLightNode({required this.resolution, required this.progress})
      : super(resolution) {
    _heartCurve = HeartCurve(size: resolution);
    _timeLine = [];
    // resource: https://opengameart.org/
    dartDecodeImage("assets/lightning.png").then((img) {
      _effectLine = EffectLine(
        texture: SpriteTexture(img),
        fadeDuration: 0.5,
        fadeAfterDelay: 0.25,
        textureLoopLength: 100.0,
        minWidth: 8.0,
        maxWidth: 20.0,
        widthMode: EffectLineWidthMode.barrel,
        animationMode: EffectLineAnimationMode.scroll,
      );
      addChild(_effectLine);
    });
    dartDecodeImage("assets/blue_flare.jpeg").then((img) {
      _spotEffect = EffectLine(
        texture: SpriteTexture(img),
        fadeDuration: 0.5,
        fadeAfterDelay: 0.25,
        textureLoopLength: 100.0,
        minWidth: 8.0,
        maxWidth: 20.0,
        widthMode: EffectLineWidthMode.barrel,
        animationMode: EffectLineAnimationMode.scroll,
      );
      addChild(_spotEffect);
    });
  }

  @override
  void update(double dt) {
    // TODO: implement update
    super.update(dt);

    double? lastTime;
    if (progress.status == AnimationStatus.forward) {
      _timeLine.add(progress.value);
    } else if (progress.status == AnimationStatus.reverse) {
      if (_timeLine.isNotEmpty) {
        lastTime = _timeLine.removeLast();
      }
    }
    if (_timeLine.length > 1) {
      for (var t in _timeLine) {
        var step = _heartCurve.transform(t);
        _effectLine.addPoint(step);
      }
    }

    if (!progress.isCompleted &&
        !progress.isDismissed &&
        _timeLine.isNotEmpty) {
      final spark = _heartCurve.transform(lastTime ?? _timeLine.last);
      _spotEffect.addPoint(spark);
    }
  }
}
