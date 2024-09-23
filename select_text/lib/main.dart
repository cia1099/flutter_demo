import 'dart:io';
import 'package:path/path.dart' as p;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

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
  late final futureDB = copyAndOpenDatabase().then((value) {
    db = value;
  });
  Database? db;

  void _incrementCounter() {
    final res = db?.select("SELECT mdx.entry FROM mdx");
    print(res?.join(" "));
    setState(() {
      _counter++;
    });
  }

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    await futureDB;
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

  Future<Database> copyAndOpenDatabase() async {
    // 获取应用程序的文档目录
    final documentsDirectory = await getApplicationDocumentsDirectory();
    print("application dir: $documentsDirectory");

    // 定义目标数据库路径
    final dbPath = p.join(documentsDirectory.path, 'example.db');

    // 检查数据库文件是否已经存在
    if (!await File(dbPath).exists()) {
      // 从 assets 中加载数据库文件
      ByteData data = await rootBundle.load('assets/example.db');

      // 创建新的文件并将数据写入
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(dbPath).writeAsBytes(bytes);
    }

    print("DB path: $dbPath");
    // 打开数据库
    return sqlite3.open(dbPath);
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
          label: 'Search',
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
