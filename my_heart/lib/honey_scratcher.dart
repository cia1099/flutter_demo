import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:my_heart/heart.dart';
import 'package:scratcher/scratcher.dart';

import 'chat_model.dart';

class HoneyScratcher extends StatelessWidget {
  final Size size;
  const HoneyScratcher({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Align(
        alignment: FractionalOffset(0.5, 0.5),
        child: CustomPaint(
          foregroundPainter: HeartPainter(
            bodyColor: Theme.of(context).scaffoldBackgroundColor,
            isShallow: true,
          ),
          child: Scratcher(
            brushSize: 30,
            threshold: 50,
            color: Colors.grey,
            rebuildOnResize: false,
            // onChange: (value) => print("Scratch progress: $value%"),
            // onThreshold: () => print("Threshold reached, you won!"),
            child: Container(
              height: size.width,
              width: size.height,
              padding: EdgeInsets.only(top: size.height * 0.25),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(ChatModel.getImage()),
                      fit: BoxFit.contain)),
              child: BorderedText(
                strokeWidth: 1.5,
                child: Text(
                  ChatModel.talk(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      Align(
        alignment: FractionalOffset(0.5, 0.1),
        child: Text(
          "刮刮乐",
          style: TextStyle(
            fontSize: 100,
            fontFamily: 'Slidefu-Regular-2',
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      Align(
        alignment: FractionalOffset(0.5, 0.925),
        child: Text(
          "每次刮开都会有不同惊喜",
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Slidefu-Regular-2',
            color: Colors.grey,
          ),
        ),
      )
    ]);
  }
}
