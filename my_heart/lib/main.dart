import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:my_heart/chat_model.dart';
import 'package:my_heart/heart.dart';
import 'package:my_heart/honey_scratcher.dart';
import 'package:url_strategy/url_strategy.dart';

import 'happy_newyear_card.dart';

void main() {
  setPathUrlStrategy();
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
      title: '程序员的浪漫',
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    _showSliders = [
      SizedBox(
        height: 800,
        width: 880,
        child: HeartAnimation(
          duration: const Duration(seconds: 3),
          bodyColor:
              Theme.of(context).scaffoldBackgroundColor, //Color(0xFFF27788),
          borderColor: const Color.fromARGB(255, 41, 17, 9),
          borderWith: 12,
          isShallow: true,
          size: const Size(880, 800),
          child: LayoutBuilder(
            builder: (context, constraints) => Container(
              height: constraints.maxWidth,
              width: constraints.maxHeight,
              padding: EdgeInsets.only(top: constraints.maxHeight * 0.25),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(ChatModel.getImage()),
                      fit: BoxFit.fill)),
            ),
          ),
        ),
      ),
      const HoneyScratcher(size: Size(800, 880)),
      const Center(child: HappyCard(size: Size(400, 440)))
    ];
  }

  @override
  Widget build(BuildContext context) {
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
            alignment: const FractionalOffset(0.5, 0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.keyboard_double_arrow_up,
                ),
                Text("上滑还有"),
              ],
            ),
          ),
        if (_currentPage < 2)
          Align(
            alignment: const FractionalOffset(0.5, 0.98),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.keyboard_double_arrow_down,
                ),
                Text("下滑还有"),
              ],
            ),
          ),
      ]),
    );
  }
}
