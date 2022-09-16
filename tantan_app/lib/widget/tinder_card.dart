import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:swipable_stack/swipable_stack.dart';

class TinderCard extends StatelessWidget {
  const TinderCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const kHorizontalOffset = 30.0;
    final netImgs = <NetworkImage>[];
    for (int i = 0; i < 10; i++)
      netImgs.add(NetworkImage("https://i.pravatar.cc/${1000 - i}"));
    return Stack(children: [
      SwipableStack(
        builder: (context, swipeProperty) {
          final idx = swipeProperty.index % netImgs.length;
          return Container(
            margin: EdgeInsets.symmetric(horizontal: kHorizontalOffset),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                image: DecorationImage(image: netImgs[idx], fit: BoxFit.cover)),
            alignment: AlignmentDirectional.bottomStart,
            child: Container(
              margin: const EdgeInsets.only(left: 20, bottom: 40),
              height: 120,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  BorderedText(
                    strokeWidth: 1.0,
                    strokeColor: Colors.black,
                    child: Text(
                      "Sample number:${swipeProperty.index + 1}",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          );
        },
      ),
      Container(
        margin: const EdgeInsets.only(
            bottom: 20, left: kHorizontalOffset, right: kHorizontalOffset),
        alignment: AlignmentDirectional.bottomStart,
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                child: const Icon(Icons.turn_left_rounded,
                    size: 30, color: Colors.amber),
                style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(10),
                    backgroundColor: const Color(0x40757575),
                    shadowColor: Colors.transparent),
              ),
            ),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () {},
                child: const Icon(Icons.close, size: 40, color: Colors.white),
                style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(30),
                    backgroundColor: const Color(0x40757575),
                    shadowColor: Colors.transparent),
              ),
            ),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () {},
                child: const Icon(Icons.favorite, size: 40, color: Colors.pink),
                style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(30),
                    backgroundColor: const Color(0x40757575),
                    shadowColor: Colors.transparent),
              ),
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                child: const Icon(Icons.star, size: 30, color: Colors.blue),
                style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(10),
                    backgroundColor: const Color(0x40757575),
                    shadowColor: Colors.transparent),
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}
