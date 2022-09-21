import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class Friendship extends StatelessWidget {
  const Friendship({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "朋友圈",
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
                height: 250,
                child: Stack(
                  children: [
                    Container(
                      //ref. https://stackoverflow.com/questions/49055676/blurred-decoration-image-in-flutter
                      decoration: const BoxDecoration(
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
                                    backgroundImage: NetworkImage(
                                        "https://i.pravatar.cc/50"),
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
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8)),
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
            ListView.builder(
              shrinkWrap: true,
              itemCount: 16,
              itemBuilder: (context, index) => Container(
                  margin: const EdgeInsets.only(bottom: 4.0),
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 16, bottom: 4),
                  // color: Colors.black54,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        "https://i.pravatar.cc/100")),
                                SizedBox(width: 8),
                                Text(
                                  "Fuck Man",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuButton(
                            itemBuilder: (context) => <PopupMenuEntry<int>>[
                              PopupMenuItem(
                                  value: 0,
                                  child: ListTile(
                                      title: Text("分享"),
                                      trailing: Icon(Icons.share))),
                              PopupMenuItem(
                                  value: 0,
                                  child: ListTile(
                                      title: Text("屏蔽"),
                                      trailing: Icon(Icons.no_accounts))),
                              PopupMenuItem(
                                  value: 0,
                                  child: ListTile(
                                      title: Text("举报内容"),
                                      trailing: Icon(
                                          Icons.accessibility_new_outlined))),
                            ],
                            icon: Icon(
                              Icons.more_horiz,
                              color: Colors.grey,
                            ),
                            shape: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                            color: Colors.white.withOpacity(0.6),
                            elevation: 0,
                          )
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ReadMoreText(
                              "幹你老即把草數據庫\n\n 了地方的馬薩看到".trim() * 30,
                              trimCollapsedText: "全文",
                              trimLength: 50,
                              trimMode: TrimMode.Length,
                              moreStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor),
                              lessStyle: TextStyle(fontSize: 0),
                            ),
                            Container(
                                height: 150,
                                width: 150,
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16)),
                                child: Image.network(
                                  "https://picsum.photos/200",
                                  fit: BoxFit.cover,
                                )),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          TextButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.favorite_outline),
                              label: Text("0")),
                          const SizedBox(width: 16),
                          TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.chat_bubble_outline),
                            label: const Text("评论"),
                          ),
                          const Expanded(child: SizedBox()),
                          Text("9/21"),
                        ],
                      )
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

class PaintLine extends CustomPainter {
  final Offset offset;
  final double length;
  final Color? color;
  final double? lineWidth;
  PaintLine(
      {required this.offset, this.length = 0, this.color, this.lineWidth});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color ?? Colors.black
      ..strokeWidth = lineWidth ?? 4
      ..style = PaintingStyle.stroke;

    final from = Offset(0, size.height) + offset;
    final to = from - Offset(0, length * 1);
    canvas.drawLine(from, to, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
