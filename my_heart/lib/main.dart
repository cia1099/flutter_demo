import 'dart:ui' as ui show Image, Gradient;
import 'dart:ui';

import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:my_heart/chat_model.dart';
import 'package:my_heart/heart.dart';
import 'package:my_heart/honey_scratcher.dart';
import 'package:my_heart/node/fireworks_node.dart';
import 'package:my_heart/utilts.dart';
import 'package:scratcher/scratcher.dart';
import 'package:spritewidget/spritewidget.dart';

import 'happy_newyear_card.dart';

void main() {
  runApp(const MyApp());
}

// Enable web can pageview
// ref. https://stackoverflow.com/questions/69424933/flutter-pageview-not-swipeable-on-web-desktop-mode
class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: AppScrollBehavior(),
      debugShowCheckedModeBanner: false,
      title: 'My Honey',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<Widget> _showSliders;
  int _currentPage = 0;
  @override
  void initState() {
    super.initState();
    _showSliders = [
      Container(
        height: 800,
        width: 880,
        child: HeartAnimation(
            duration: Duration(seconds: 3),
            bodyColor: Color(0xFFF27788),
            borderColor: Color.fromARGB(255, 41, 17, 9),
            borderWith: 12,
            size: Size(880, 800)),
      ),
      HoneyScratcher(size: Size(800, 880)),
      Center(child: HappyCard(size: Size(400, 440)))
    ];
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(children: [
        Center(
            // child: HeartAnimation(
            //     duration: Duration(seconds: 3),
            //     bodyColor: Color(0xFFF27788),
            //     borderColor: Color.fromARGB(255, 41, 17, 9),
            //     borderWith: 12,
            //     size: Size(880, 800)),
            //===== Heart Text
            // child: HoneyScratcher(size: Size(800, 880)),
            // === Happy New Year
            // child: HappyCard(
            //   size: const Size(400, 440),
            //   background: scenery,
            // ),
            child: PageView(
          scrollDirection: Axis.vertical,
          children: _showSliders,
          onPageChanged: (value) => setState(() {
            _currentPage = value;
          }),
        )),
        if (_currentPage > 0)
          Align(
            alignment: FractionalOffset(0.5, 0.05),
            child: Icon(
              Icons.keyboard_double_arrow_up,
            ),
          ),
        if (_currentPage < 2)
          Align(
            alignment: FractionalOffset(0.5, 0.98),
            child: Icon(
              Icons.keyboard_double_arrow_down,
            ),
          ),
      ]),
    );
  }
}
