import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    //print(dbPath.toString());
    return sql.openDatabase(
      path.join(dbPath, 'user_details.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE user_details (id TEXT PRIMARY KEY, weight TEXT)');
      },
      version: 1,
    );
  }

  static Future<void> insert(String table, Map<String, dynamic> data) async {
    final db = await DBHelper.database();
    db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    //print('oooo');
    final db = await DBHelper.database();
    //print('kk');
    return db.query(table);
  }
}
