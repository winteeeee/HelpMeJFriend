import 'package:help_me_j_friend/persistence/entity/task.dart';
import 'package:help_me_j_friend/persistence/repository/repository.dart';
import 'package:sqflite/sqflite.dart';

class TaskRepository extends Repository<Task> {
  String tableName = "task";

  @override
  Future<List<Task>> findAll() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(tableName);

    return List.generate(maps.length, (index) {
      return Task.toEntity(maps[index]);
    });
  }

  @override
  Future<Task> findById(id) async {
    Database db = await database;
    List<Map<String, dynamic>> map = await db.query(tableName, where: "id = ?", whereArgs: [id]);
    return Task.toEntity(map[0]);
  }
}