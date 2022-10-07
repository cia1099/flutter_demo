import 'dart:isolate';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:explore/widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class DecodeParam {
  final ByteData byteData;
  final SendPort sendPort;

  DecodeParam(this.byteData, this.sendPort);
}

class DestinationCarousel extends StatefulWidget {
  @override
  _DestinationCarouselState createState() => _DestinationCarouselState();
}

class _DestinationCarouselState extends State<DestinationCarousel>
    with TickerProviderStateMixin {
  final String imagePath = 'assets/images/';

  late CarouselController _controller; // = CarouselController();

  List _isHovering = [false, false, false, false, false, false, false];
  List _isSelected = [true, false, false, false, false, false, false];

  int _current = 0;
  List<Widget>? txtSliders;
  late Animation<double> _animation;
  late AnimationController _aniController;

  final List<String> images = [
    'assets/images/asia.jpg',
    'assets/images/africa.jpg',
    'assets/images/europe.jpg',
    'assets/images/south_america.jpg',
    'assets/images/australia.jpg',
    'assets/images/antarctica.jpg',
  ];

  final List<String> places = [
    'ASIA',
    'AFRICA',
    'EUROPE',
    'SOUTH AMERICA',
    'AUSTRALIA',
    'ANTARCTICA',
  ];

  @override
  void initState() {
    _aniController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 4100))
          ..forward();
    _animation = Tween<double>(begin: 2.0, end: 1.0).animate(
        CurvedAnimation(parent: _aniController, curve: Curves.easeInOutCirc));
    _controller = CarouselController();

    super.initState();
  }

  @override
  void dispose() {
    _aniController.dispose();
    super.dispose();
  }

  List<Widget> generateImageTiles(screenSize) {
    return images.map(
      (element) {
        return ClipRRect(
          key: ValueKey<int>(images.indexWhere((item) => item == element)),
          borderRadius: BorderRadius.circular(8.0),
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              if (_animation.value < 1.7 && _animation.value > 1.2) {
                String filePath =
                    element.substring(0, element.length - 4) + '_blur.jpg';
                child = Image.asset(filePath);
              }
              return Transform.scale(child: child, scale: _animation.value);
            },
            child: Image.asset(
              element,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    ).toList();
  }

  // List<Widget> generateImageTiles(screenSize) {
  //   // var rp = ReceivePort();
  //   return images.map((element) {
  //     return ClipRRect(
  //       borderRadius: BorderRadius.circular(8.0),
  //       child: AnimatedBuilder(
  //           animation: _animation,
  //           builder: (context, child) {
  //             return Transform.scale(child: child, scale: _animation.value);
  //           },
  //           child: FutureBuilder(
  //             future: rootBundle.load(element),
  //             builder: (context, snapshot) {
  //               // futureData.then((data) {
  //               // });
  //               // rp.first.then((value) {
  //               //   final mm = value as img.Image;
  //               //   child = Image.memory(mm.getBytes());
  //               // });
  //               if (snapshot.connectionState != ConnectionState.done) {
  //                 return Image.asset(
  //                   element,
  //                   fit: BoxFit.cover,
  //                 );
  //               }
  //               final data = snapshot.data! as ByteData;
  //               // Isolate.spawn<DecodeParam>((message) {
  //               final src = img.decodeImage(data.buffer.asUint8List());
  //               img.drawString(src!, img.arial_48, 520, 50, "Hello Thread");
  //               // message.sendPort.send(src);
  //               // }, DecodeParam(data, rp.sendPort));
  //               return Image.memory(
  //                 src.getBytes(format: img.Format.rgba),
  //                 width: src.width.toDouble(),
  //                 height: src.height.toDouble(),
  //               );
  //             },
  //           )),
  //     );
  //   }).toList();
  // }

  List<Widget> generateTextTiles(screenSize, ctx) {
    return places
        .map((e) => Center(
              child: AutoSizeText(
                e,
                style: GoogleFonts.electrolize(
                  letterSpacing: 8,
                  fontSize: screenSize.width / 16,
                  color: Theme.of(ctx).bottomAppBarColor,
                ),
                maxLines: 1,
              ),
            ))
        .toList();
  }

  Widget _createTextTiles(screenSize, str, myColor) {
    return Center(
      child: AutoSizeText(
        str,
        style: GoogleFonts.electrolize(
          letterSpacing: 8,
          fontSize: screenSize.width / 16,
          color: myColor,
        ),
        maxLines: 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var imageSliders = generateImageTiles(screenSize);
    if (txtSliders == null) {
      txtSliders = generateTextTiles(screenSize, context);
      txtSliders![_current] = _createTextTiles(
          screenSize, places[_current], Colors.white.withOpacity(0.7));
    }

    return Stack(
      children: [
        Center(
          child: SizedBox(
            width: screenSize.width * 3 / 4,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 200),
                  transitionBuilder: (child, animation) => SlideTransition(
                        position: Tween<Offset>(
                                begin: Offset(0, 1), end: Offset(0, 0))
                            .animate(animation),
                        child: child,
                      ),
                  child: imageSliders[_current]),
            ),
          ),
        ),
        CarouselSlider(
          items: txtSliders,
          options: CarouselOptions(
            viewportFraction: 0.6,
            enlargeCenterPage: true,
            aspectRatio: 18 / 8,
            autoPlay: true,
            onPageChanged: (index, reason) {
              txtSliders![_current] = _createTextTiles(screenSize,
                  places[_current], Theme.of(context).bottomAppBarColor);
              setState(() {
                _current = index;
                for (int i = 0; i < txtSliders!.length; i++) {
                  if (i == index) {
                    _isSelected[i] = true;
                    txtSliders![i] = _createTextTiles(
                        screenSize, places[i], Colors.white.withOpacity(0.7));
                  } else {
                    _isSelected[i] = false;
                  }
                }
              });
              _aniController.forward(from: 0);
            },
          ),
          carouselController: _controller,
        ),
        ResponsiveWidget.isSmallScreen(context)
            ? Container()
            : AspectRatio(
                aspectRatio: 17 / 8,
                child: Center(
                  heightFactor: 1,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: screenSize.width / 8,
                        right: screenSize.width / 8,
                      ),
                      child: Card(
                        elevation: 5,
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: screenSize.height / 50,
                            bottom: screenSize.height / 50,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              for (int i = 0; i < places.length; i++)
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      onHover: (value) {
                                        setState(() {
                                          value
                                              ? _isHovering[i] = true
                                              : _isHovering[i] = false;
                                        });
                                      },
                                      onTap: () {
                                        _controller.animateToPage(i);
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            top: screenSize.height / 80,
                                            bottom: screenSize.height / 90),
                                        child: Text(
                                          places[i],
                                          style: TextStyle(
                                            color: _isHovering[i]
                                                ? Theme.of(context)
                                                    .primaryTextTheme
                                                    .button!
                                                    .decorationColor
                                                : Theme.of(context)
                                                    .primaryTextTheme
                                                    .button!
                                                    .color,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      maintainSize: true,
                                      maintainAnimation: true,
                                      maintainState: true,
                                      visible: _isSelected[i],
                                      child: AnimatedOpacity(
                                        duration: Duration(milliseconds: 400),
                                        opacity: _isSelected[i] ? 1 : 0,
                                        child: Container(
                                          height: 5,
                                          decoration: BoxDecoration(
                                            color: Colors.blueGrey,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                          ),
                                          width: screenSize.width / 10,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
      ],
    );
  }
}
