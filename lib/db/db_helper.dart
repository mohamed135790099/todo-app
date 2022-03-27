import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/models/task.dart';


class DBHelper {
  static Database? _db;
  static const int _version = 1;
  static const String _tableName = 'Tasks';


  static Future<void> initDb() async {
    if (_db != null) {
      debugPrint('not null db');
      return;
    } else {
      try {
        debugPrint('in database path444444');

        // Get a location using getDatabasesPath
        String _path = await getDatabasesPath()+'task.db';
        debugPrint('in database path');
        // open the database
        _db = await openDatabase(_path, version: _version,
            onCreate: (Database db, int version) async {
          // When creating the db, create the table
              await db.execute(
                  'CREATE TABLE $_tableName ('
                      'id INTEGER PRIMARY KEY AUTOINCREMENT,'
                      'title STRING,note TEXT,date STRING,'
                      'startTime STRING,endTime STRING,'
                      'remind INTEGER,repeat STRING ,'
                      ' color INTEGER,'
                      ' isCompleted INTEGER)',);});
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  static Future<int> insert(Task task) async {
    try{
        debugPrint('Insert Function Call');
      return await _db!.insert(_tableName, task.toJson());
    }
    catch(e){
      debugPrint('We are here$e');
      return 90000;
    }
  }

  static Future<int> delete(Task task) async {
    debugPrint('Delete Function Call');
    return await _db!.delete(_tableName, where: 'id=?', whereArgs: [task.id]);
  }
  static Future<int> deleteAll() async {
    debugPrint('Delete Function Call');
    return await _db!.delete(_tableName);
  }

  static Future<List<Map<String, dynamic>>> query() async {
    debugPrint('Query Function Call');

    return await _db!.query(_tableName);
  }

  static Future<int> update(int id) async {
    debugPrint('Update Function Call');
    return await _db!.rawUpdate('''
    UPDATE tasks
    SET isCompleted = ?
    WHERE id = ?
    
  ''', [1, id]);
  }
}
