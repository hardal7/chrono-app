import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

late String dbPath;
Future<void> initLocalDB() async {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  } else if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }

  var databasesPath = await getDatabasesPath();
  dbPath = p.join(databasesPath, 'local.db');
  debugPrint('Init local DB on path: $dbPath');
}

Future<Database> openLocalDatabase() async {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    return await databaseFactory.openDatabase(
      dbPath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (Database db, int version) async {
          await _createDB(db);
        },
      ),
    );
  } else {
    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (Database db, int version) async {
        await _createDB(db);
      },
    );
  }
}

Future<void> _createDB(Database db) async {
  await db.execute('''
  CREATE TABLE IF NOT EXISTS topic_events (
    id INTEGER NOT NULL PRIMARY KEY,
    topic_name TEXT NOT NULL,
    time_tracked_seconds INTEGER NOT NULL DEFAULT 0,
    synced INTEGER NOT NULL DEFAULT FALSE,
    created_at TEXT NOT NULL DEFAULT (datetime('now'))
  );

  CREATE TABLE IF NOT EXISTS topics (
    id INTEGER NOT NULL PRIMARY KEY,
    topic_name TEXT NOT NULL UNIQUE,
    total_time_tracked_seconds INTEGER NOT NULL DEFAULT 0,
    synced INTEGER NOT NULL DEFAULT FALSE
  );
  INSERT OR IGNORE INTO topics (topic_name, synced) VALUES ('General', 1);

  CREATE TABLE IF NOT EXISTS user_stats (
    id INTEGER NOT NULL PRIMARY KEY,
    today_time_tracked_seconds INTEGER NOT NULL DEFAULT 0,
    streak INTEGER NOT NULL DEFAULT 0
  );
  INSERT OR IGNORE INTO user_stats (id) VALUES (1);
  ''');
}
