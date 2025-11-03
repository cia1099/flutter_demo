import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class MyDB {
  late final String _appDirectory;
  static MyDB? _instance;
  MyDB._internal() {
    _init()
        .whenComplete(() {
          _completer.complete(true);
        })
        .onError((_, __) {
          _completer.completeError(false);
        });
  }
  static MyDB get instance => _instance ??= MyDB._internal();
  factory MyDB() => instance;

  Future<void> _init() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    debugPrint("Application directory: $documentsDirectory");
    _appDirectory = documentsDirectory.path;
  }

  String get appDirectory => _appDirectory;

  final _completer = Completer<bool>();
  Future<bool> get isReady => _completer.future;
}
