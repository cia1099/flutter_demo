import 'package:flutter/material.dart';
import 'package:swipable_stack/swipable_stack.dart';

class TinderCard extends StatelessWidget {
  const TinderCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        margin: const EdgeInsets.symmetric(
          horizontal: 25,
        ),
        child: Stack(children: [
          SwipableStack(
            builder: (context, swipeProperty) => Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  image: const DecorationImage(
                      image: NetworkImage("https://i.pravatar.cc/1000"),
                      fit: BoxFit.cover)),
              alignment: AlignmentDirectional.bottomStart,
              child: Container(
                margin: const EdgeInsets.only(left: 20, bottom: 40),
                height: 120,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      "Sample number:${swipeProperty.index + 1}",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            alignment: AlignmentDirectional.bottomStart,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Icon(Icons.turn_left_rounded,
                      size: 35, color: Colors.amber),
                  style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(25),
                      backgroundColor: const Color(0x40757575),
                      shadowColor: Colors.transparent),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Icon(Icons.close, size: 35, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(25),
                      backgroundColor: const Color(0x40757575),
                      shadowColor: Colors.transparent),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child:
                      const Icon(Icons.favorite, size: 35, color: Colors.pink),
                  style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(25),
                      backgroundColor: const Color(0x40757575),
                      shadowColor: Colors.transparent),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Icon(Icons.star, size: 35, color: Colors.blue),
                  style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(25),
                      backgroundColor: const Color(0x40757575),
                      shadowColor: Colors.transparent),
                ),
              ],
            ),
          )
        ]));
  }
}
