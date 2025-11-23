import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_management_pro_codex/core/constants/database_constants.dart';
import 'package:task_management_pro_codex/core/providers/database/database_schema.dart';

class DatabaseHelper {
  static Database? _db;
  static DatabaseHelper? _databaseHelper;

  DatabaseHelper._createInstance();

  static final DatabaseHelper db = DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    _databaseHelper ??= DatabaseHelper._createInstance();
    return _databaseHelper!;
  }

  Future<Database> get database async {
    _db ??= await initializeDatabase();
    return _db!;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = '${directory.path}/${DatabaseConstants.dbName}';
    var myDatabase = await openDatabase(
      path,
      version: DatabaseConstants.dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    return myDatabase;
  }

  Future _onCreate(Database db, int version) async {
    // Apply all migrations up to the current version
    for (int i = 1; i <= version; i++) {
      if (DatabaseSchema.migrations.containsKey(i)) {
        for (String query in DatabaseSchema.migrations[i]!) {
          await db.execute(query);
        }
      }
    }
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Apply all migrations between the old and new versions
    for (int i = oldVersion + 1; i <= newVersion; i++) {
      if (DatabaseSchema.migrations.containsKey(i)) {
        for (String query in DatabaseSchema.migrations[i]!) {
          await db.execute(query);
        }
      }
    }
  }
}
