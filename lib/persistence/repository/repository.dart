import 'package:help_me_j_friend/persistence/entity/entity.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

abstract class Repository<T extends Entity> {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    return await openDatabase(
        'jfriend.db',
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''PRAGMA foreign_keys = ON''');

          await db.execute('''
          CREATE TABLE Position (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL,
              latitude REAL NOT NULL,
              longitude REAL NOT NULL
          )
          ''');

          await db.execute('''
          CREATE TABLE Task (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL,
              start_time TEXT NOT NULL,
              end_time TEXT NOT NULL,
              position_id INTEGER NOT NULL,
              plan_id INTEGER NOT NULL,
              FOREIGN KEY (position_id) REFERENCES Position(id) ON DELETE CASCADE
              FOREIGN KEY (plan_id) REFERENCES Plan(id)
          )
          ''');

          await db.execute('''
          CREATE TABLE Plan (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL,
              start_date TEXT NOT NULL,
              end_date TEXT NOT NULL,
              accommodation_position_id INTEGER NOT NULL,
              FOREIGN KEY (accommodation_position_id) REFERENCES Position(id) ON DELETE CASCADE
          )
          ''');
        }
    );
  }
  
  Future<int> insert(T t) async {
    Database db = await database;
    return await db.insert(T.toString(), t.toMap());
  }

  Future<void> update(T t) async {
    Database db = await database;
    await db.update(T.toString(), t.toMap(), where: 'id = ?', whereArgs: [t.id]);
  }

  Future<void> delete(T t) async {
    Database db = await database;
    await db.delete(T.toString(), where: "id = ?", whereArgs: [t.id]);
  }

  Future<void> deleteAll(List<T> list) async {
    Database db = await database;
    for (T t in list) {
      await db.delete(T.toString(), where: "id = ?", whereArgs: [t.id]);
    }
  }

  Future<List<T>> findAll();
  Future<T> findById(id);
}