import 'package:html_flutter/src/db_dictionary.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

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
                  style: TextStyle(fontSize: 30),
                );
              },
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SelectionArea(
              contextMenuBuilder: (context, selectableRegionState) {
                // final buttons = selectableRegionState.contextMenuButtonItems;
                // print(buttons.map((e) => e.label));
                // final text = selectableRegionState.textEditingValue.text;
                // print(text);
                // final offset =
                //     selectableRegionState.contextMenuAnchors.primaryAnchor;
                // final end = selectableRegionState.selectionEndpoints;
                // print("\x1b[43;1m$offset\x1b[0m");
                // print("\x1b[43;1m$end\x1b[0m");
                final ed = context.findAncestorStateOfType<EditableTextState>();
                print("enditable = $ed");
                // 返回自定义工具栏
                return CustomTextSelectionToolbar(
                    selectableRegionState: selectableRegionState);
              },
              // onSelectionChanged: (value) {
              //   print(value?.plainText);
              // },
              child: HtmlWidget(
                key: selectedKey,
                html,
                customStylesBuilder: (element) {
                  final cssMap = {
                    'ml-1em': {'margin-left': '1em'},
                    'ml-2em': {'margin-left': '2em'},
                    'color-navy': {'color': 'navy'},
                    'color-purple': {'color': 'purple'},
                    'color-darkslategray': {
                      'color': 'darkslategray',
                      'font-weight': 'bold',
                      'font-style': 'italic'
                    },
                    'color-gray': {'color': 'gray'},
                    'color-blue': {'color': 'blue'},
                    'color-dodgerblue': {'color': 'dodgerblue'},
                    'bold': {'font-weight': 'bold'},
                    'italic': {'font-style': 'italic'}
                  };
                  for (final className in element.classes) {
                    return cssMap[className];
                  }
                  return null;
                },
                onTapUrl: (url) {
                  print('tapped $url');
                  return true;
                },
                textStyle: TextStyle(
                  fontSize: 32,
                ),
              ),
            ),
            // Image.asset(
            //   "assets/playsound.png",
            //   width: 50,
            // )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CustomTextSelectionToolbar extends StatelessWidget {
  final SelectableRegionState selectableRegionState;
  final GlobalKey<EditableTextState> editableTextKey =
      GlobalKey<EditableTextState>();

  CustomTextSelectionToolbar({Key? key, required this.selectableRegionState})
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
