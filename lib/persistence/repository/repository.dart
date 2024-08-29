import 'package:help_me_j_friend/persistence/entity/entity.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class Repository<T extends Entity> {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'jfriend.db');

    return await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
          CREATE TABLE position (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL,
              latitude REAL NOT NULL,
              longitude REAL NOT NULL
          )
          ''');

          await db.execute('''
          CREATE TABLE task (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL,
              start_time TEXT NOT NULL,
              end_time TEXT NOT NULL,
              position_id INTEGER NOT NULL,
              plan_id INTEGER NOT NULL,
              FOREIGN KEY (position_id) REFERENCES position(id)
              FOREIGN KEY (plan_id) REFERENCES plan(id)
          )
          ''');

          await db.execute('''
          CREATE TABLE plan (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL,
              start_date TEXT NOT NULL,
              end_date TEXT NOT NULL,
              accommodation_position_id INTEGER NOT NULL,
              plan_activity_start_time TEXT NOT NULL,
              plan_activity_end_time TEXT NOT NULL,
              FOREIGN KEY (accommodation_position_id) REFERENCES position(id)
          )
          ''');
        }
    );
  }
  
  Future<int> insert(T t) async {
    Database db = await database;
    return await db.insert(t.getTableName(), t.toMap());
  }

  Future<void> update(T t) async {
    Database db = await database;
    await db.update(t.getTableName(), t.toMap(), where: 'id = ?', whereArgs: [t.id]);
  }

  Future<void> delete(T t) async {
    Database db = await database;
    await db.delete(t.getTableName(), where: "id = ?", whereArgs: [t.id]);
  }

  Future<List<T>> findAll();
  Future<T> findById(id);
}