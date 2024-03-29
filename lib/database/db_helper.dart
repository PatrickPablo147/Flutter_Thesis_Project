/*This Class Manage the Creation and Controls of Database*/
import 'package:sqflite/sqflite.dart';
import '../models/task.dart';

class DBHelper{
  static Database? _db;
  static final int _version = 1;
  static final String _tableName = "tasks";

  static Future<void> initDb() async {
    //Check if database is not empty
    if (_db != null) {
      return;
    }
    //Create the path and the database File
    try {
      String path = await getDatabasesPath() + 'tasks.db';
      _db = await openDatabase(
        path,
        version: _version,
        onCreate: (db, version) {
          return db.execute(
            "CREATE TABLE $_tableName("
                "id INTEGER PRIMARY KEY AUTOINCREMENT, "
                "title STRING, note TEXT, date STRING, "
                "startTime STRING, endTime STRING, "
                "remind INTEGER, repeat STRING, "
                "color INTEGER, "
                "isCompleted INTEGER )",
          );
        },
      );
    }
    catch (e) {
      print(e);
    }
  }
  // Save input from data to Json file
  static Future<int> insert(Task? task) async {
    return await _db?.insert(_tableName, task!.toJson())??1;
  }
  //show Query
  static Future<List<Map<String, dynamic>>> query() async {
    return await _db!.query(_tableName);
  }
  //delete Data depending on Database ID
  static delete(Task task) async {
    return await _db!.delete(_tableName, where: 'id=?', whereArgs: [task.id]);
  }
  //update the Data in Database
  static update(int id) async {
    return await _db!.rawUpdate('''
      UPDATE tasks
      SET isCompleted = ?
      WHERE id = ?
    ''', [1, id]);
  }

  static updateDateTime(String date, String startTime, int id) async {
    return await _db!.rawUpdate('''
      UPDATE tasks
      SET date = ?,
          startTime = ?,
          isCompleted = ?
      WHERE id = ?
    ''', [date, startTime, 0, id]);
  }

}