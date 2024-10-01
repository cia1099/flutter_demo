import 'dart:math';

import 'package:html_flutter/src/db_dictionary.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:html_flutter/src/lookup_sheet.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final selectedKey = GlobalKey();
  final db = DBDictionary();

  void _incrementCounter() {
    final res = db.select("SELECT entry FROM mdx").map((row) => row['entry']);
    print(res.join(" "));
    print(res);
    setState(() {
      _counter++;
    });
  }

  final html = '''
    <div class="ml-1em">
    <span class="color-navy"><b>limp</b></span>
    <span class="color-purple">/<a href="asset:assets/limp.mp3"><img src="asset:assets/playsound.png"/></a> lɪmp/ </span>
    <span class="color-darkslategray">{pos}</span>
    </div>
    <div class="ml-2em">
    {definition}
    </div>
  ''';
  final words = ['doe', 'limp', 'ray'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StatefulBuilder(
              builder: (context, setState) {
                final sentence = 'You have pushed the button this many times:\n'
                    .split(" ")
                    .expand((word) sync* {
                  yield word.contains("\n") ? word.replaceAll("\n", "") : word;
                  if (!word.contains("\n")) yield " ";
                });
                return SelectableText.rich(
                  TextSpan(
                      children: sentence
                          .map((word) => TextSpan(text: word))
                          .toList()),
                  style: TextStyle(fontSize: 16),
                );
              },
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SelectionArea(
                contextMenuBuilder: (ctx, selectableRegionState) =>
                    CustomTextSelectionToolbar(
                      selectableRegionState: selectableRegionState,
                      scaffoldContext: context,
                    ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    List.generate(
                            30, (i) => words[Random().nextInt(words.length)])
                        .join(" "),
                    style: TextStyle(fontSize: 24),
                    overflow: TextOverflow.visible,
                  ),
                ))
            // Image.asset(
            //   "assets/playsound.png",
            //   width: 50,
            // )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        //     () => showModalBottomSheet(
        //   context: context,
        //   builder: (context) => Container(
        //     height: 300,
        //     color: Colors.green,
        //   ),
        // ),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CustomTextSelectionToolbar extends StatelessWidget {
  final SelectableRegionState selectableRegionState;
  final BuildContext scaffoldContext;

  CustomTextSelectionToolbar(
      {Key? key,
      required this.selectableRegionState,
      required this.scaffoldContext})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdaptiveTextSelectionToolbar.buttonItems(
      buttonItems: [
        ContextMenuButtonItem(
          label: '复制',
          type: ContextMenuButtonType.copy,
          onPressed: () {
            selectableRegionState.copySelection(SelectionChangedCause.toolbar);
            // Clipboard.setData(ClipboardData(
            //     text: selectableRegionState.textEditingValue.text));
          },
        ),
        ContextMenuButtonItem(
          label: 'Look Up',
          type: ContextMenuButtonType.lookUp,
          onPressed: () {
            Clipboard.getData("text/plain").then(
              (cache) {
                final tmp = cache?.text;
                selectableRegionState.copySelection(SelectionChangedCause.drag);
                print(selectableRegionState.textEditingValue.text);
                Clipboard.getData("text/plain").then(
                  (data) {
                    if (tmp != null) {
                      Clipboard.setData(ClipboardData(text: tmp));
                    }
                    print(data?.text);
                    showModalBottomSheet(
                        useSafeArea: true,
                        context: scaffoldContext,
                        showDragHandle: true,
                        scrollControlDisabledMaxHeightRatio: 15.5 / 16,
                        builder: (context) => LookUpSheet(word: data!.text!));
                  },
                );
              },
            );
          },
        ),
        ContextMenuButtonItem(
          label: '粘贴',
          type: ContextMenuButtonType.paste,
          onPressed: () {
            // editableTextState.pasteText(SelectionChangedCause.keyboard);
          },
        ),
        ContextMenuButtonItem(
          label: '自定义操作',
          onPressed: () {
            // 你可以在这里添加自定义逻辑
            print('自定义操作');
          },
        ),
      ],
      anchors: selectableRegionState.contextMenuAnchors,
    );
  }
}
