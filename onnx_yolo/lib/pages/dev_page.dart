import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onnxruntime/flutter_onnxruntime.dart';
import 'package:onnx_yolo/utils/image.dart';

import '../frosted_button.dart';
import '../non_maximum_suppression.dart';
import '../ort_yolo.dart';
import 'detect_page.dart';

class DevPage extends StatefulWidget {
  const DevPage({super.key});

  @override
  State<DevPage> createState() => _DevPageState();
}

class _DevPageState extends State<DevPage> {
  late final ortYolo = OrtYolo(isAndroid: false);
  final boxes = PaintingBoxes();
  Timer? timer;
  final streamController = StreamController<ui.Image>();
  late final image = dartDecodeImage("assets/bus.jpg", context).then((img) {
    streamController.add(img);
    return img;
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Detecting Object"),
        leading: FutureBuilder(
          future: OnnxRuntime().getAvailableProviders(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return SizedBox.shrink();
            return MenuBar(
              children: [
                SubmenuButton(
                  menuChildren: snapshot.data!.map((p) {
                    return Text(p.name);
                  }).toList(),
                  child: Text("EP"),
                ),
              ],
            );
          },
        ),
      ),
      child: Stack(
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
                    isAndroid: false,
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
              onPressed: () async {
                timer?.cancel();
                boxes << await ortYolo(await image);
                timer = Timer(Durations.extralong4 * 2, () => boxes << []);
              },
              icon: CupertinoIcons.play,
              size: 100,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    ortYolo.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    await image;
  }
}
