import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

class DBDictionary {
  Database? _database;

  /// Individual object
  // final String _dbName;
  // DBDictionary(String dbName) : _dbName = dbName {
  //   copyAndOpenDatabase('assets/$_dbName').then((db) => _database = db);
  // }

  /// Singleton pattern
  static const _dbName = 'example.db';
  static DBDictionary? _instance;
  DBDictionary._internal() {
    copyAndOpenDatabase('assets/$_dbName').then((db) => _database = db);
  }
  static DBDictionary get instance => _instance ??= DBDictionary._internal();
  factory DBDictionary() => instance;

  ResultSet select(String sqlSelect, [List<Object?> parameters = const []]) {
    try {
      return _database!.select(sqlSelect, parameters);
    } on Error catch (_) {
      //https://stackoverflow.com/questions/48968722/is-there-support-for-predefined-macros-in-dart
      throw Exception("Database is not connected successfully");
    } catch (e) {
      rethrow;
    }
  }

  String lookUp(String word) {
    const query = 'SELECT mdx.paraphrase FROM mdx WHERE mdx.entry = ?';
    final res = select(query, [word]).map<String>((row) => row['paraphrase']);
    return res.join("\n" + "=" * 64 + "\n");
  }

  /// dart will automatically call dispose() if you had defined it
  void dispose() {
    _database?.dispose();
  }

  Future<Database> copyAndOpenDatabase(String assetPath) async {
    // 获取应用程序的文档目录
    final documentsDirectory = await getApplicationDocumentsDirectory();
    debugPrint("Application directory: $documentsDirectory");

    // 定义目标数据库路径
    final dbPath = p.join(documentsDirectory.path, _dbName);

    // 检查数据库文件是否已经存在
    if (!await File(dbPath).exists()) {
      // 从 assets 中加载数据库文件
      ByteData data = await rootBundle.load(assetPath);

      // 创建新的文件并将数据写入
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(dbPath).writeAsBytes(bytes);
      debugPrint("DB path: $dbPath");
    }

    // 打开数据库
    return sqlite3.open(dbPath);
  }
}
