import 'package:flutter/material.dart';

class ChatList extends StatefulWidget {
  const ChatList({
    Key? key,
  }) : super(key: key);

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  int _selectMenu = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "讯息",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: SizedBox(
                height: 40,
                child: TextFormField(
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(color: Colors.transparent)),
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(color: Colors.transparent)),
                    hintText: "搜寻 个配对",
                    filled: true,
                    fillColor: Colors.grey[150],
                    contentPadding: const EdgeInsets.all(8),
                  ),
                ),
              ),
            ),
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "讯息",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  PopupMenuButton(
                    itemBuilder: (contxt) {
                      final txtStyle =
                          TextStyle(color: Theme.of(context).primaryColor);
                      return <PopupMenuEntry<int>>[
                        PopupMenuItem(
                            value: 0,
                            child: ListTile(
                              leading: Text(
                                "全部",
                                style: _selectMenu == 0 ? txtStyle : null,
                              ),
                              trailing: _selectMenu == 0
                                  ? Icon(Icons.check,
                                      color: Theme.of(context).primaryColor)
                                  : null,
                            )),
                        PopupMenuItem(
                            value: 1,
                            child: ListTile(
                              leading: Text(
                                "对话",
                                style: _selectMenu == 1 ? txtStyle : null,
                              ),
                              trailing: _selectMenu == 1
                                  ? Icon(Icons.check,
                                      color: Theme.of(context).primaryColor)
                                  : null,
                            )),
                        PopupMenuItem(
                            value: 2,
                            child: ListTile(
                              leading: Text(
                                "配对",
                                style: _selectMenu == 2 ? txtStyle : null,
                              ),
                              trailing: _selectMenu == 2
                                  ? Icon(Icons.check,
                                      color: Theme.of(context).primaryColor)
                                  : null,
                            )),
                      ];
                    },
                    icon: const Icon(
                      Icons.menu,
                      color: Colors.grey,
                    ),
                    shape: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    onSelected: (value) => setState(() {
                      _selectMenu = value;
                    }),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 14,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    height: 90,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Row(children: [
                            CircleAvatar(
                              backgroundImage:
                                  NetworkImage("https://i.pravatar.cc/100"),
                              radius: 36,
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            Expanded(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Shit Man",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                Text(
                                  "Hello TanTan",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(
                                  height: 4,
                                )
                              ],
                            )),
                          ]),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(
                            "2022/09/19",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
