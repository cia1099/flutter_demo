import 'dart:ui';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_web_frame/flutter_web_frame.dart';
import 'package:tantan_app/widget/chat_list.dart';
import 'package:tantan_app/widget/friendship.dart';

import 'widget/tinder_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FlutterWebFrame(
      builder: (context) => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
              titleTextStyle: TextStyle(
                  // color: Colors.amber[900],
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0),
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(100, 50),
                  backgroundColor: const Color(0xffff6f00),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)))),
          // textTheme: TextTheme(),
          primarySwatch: Colors.blue,
          primaryColor: const Color(0xffff6f00),
        ),
        home: const MyHomePage(),
      ),
      maximumSize: const Size(400, 812.0),
      enabled: kIsWeb,
      backgroundColor: Colors.grey,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 3;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  List<Widget> _widgetOptions = <Widget>[
    TinderCard(),
    Text(
      'Index 1: School',
      style: optionStyle,
    ),
    ChatList(),
    Column(
      children: [
        SizedBox(
            height: 250,
            child: Stack(
              children: [
                Container(
                  //ref. https://stackoverflow.com/questions/49055676/blurred-decoration-image-in-flutter
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage("https://i.pravatar.cc/300"),
                          fit: BoxFit.cover)),
                  child: ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
                CustomPaint(
                  painter: PaintLine(
                      // padding + circleAvatar in x-dir
                      offset: Offset(52, 0),
                      length: 100,
                      color: Colors.white,
                      lineWidth: 2),
                  child: Container(
                    padding: EdgeInsets.only(left: 30, bottom: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 22,
                              child: CircleAvatar(
                                backgroundImage:
                                    NetworkImage("https://i.pravatar.cc/50"),
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text("Shit",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.transparent,
                            ),
                            SizedBox(
                              height: 40,
                              child: OutlinedButton.icon(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.chat_bubble,
                                    color: Colors.grey,
                                    size: 16,
                                  ),
                                  label: Text(
                                    "讯息列表",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: Colors.grey),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )),
        Expanded(
            child: Container(
          margin: EdgeInsets.all(8.0),
          color: Colors.green,
        )),
      ],
    ),
    Text(
      'Index 4: School',
      style: optionStyle,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (_selectedIndex != 0 && _selectedIndex != 2)
          ? AppBar(
              title: Text(
                "TANTAN",
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            )
          : null,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            label: '探索',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.live_tv),
            label: '直播',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message_outlined),
            label: '讯息',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: '发现',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '我',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
