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

  Future<List<Task>> findByPlanId(id) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.rawQuery("""
    SELECT * FROM Task WHERE plan_id = $id
    """);

    return List.generate(maps.length, (index) {
      return Task.toEntity(maps[index]);
    });
  }

  Future<List<Task>> findTodayTasks(today, tomorrow) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.rawQuery("""
      SELECT * FROM Task WHERE '$today' <= start_time AND '$tomorrow' >= start_time
    """);

    return List.generate(maps.length, (index) {
      return Task.toEntity(maps[index]);
    });
  }
  
  Future<bool> isDuplicated(int? id, startTime, endTime) async {
    Database db = await database;
    List<Map<String, dynamic>> maps;

    if (id != null) {
      maps = await db.rawQuery("""
        SELECT *
        FROM Task
        WHERE id != $id AND (('$startTime' < start_time AND end_time < '$endTime')
        OR ('$startTime' < start_time AND start_time < '$endTime')
        OR ('$startTime' < end_time AND end_time < '$endTime')
        OR (start_time < '$startTime' AND '$endTime' < end_time))
      """);
    } else {
      maps = await db.rawQuery("""
        SELECT *
        FROM Task
        WHERE ('$startTime' < start_time AND end_time < '$endTime')
        OR ('$startTime' < start_time AND start_time < '$endTime')
        OR ('$startTime' < end_time AND end_time < '$endTime')
        OR (start_time < '$startTime' AND '$endTime' < end_time)
      """);
    }

    return maps.isNotEmpty;
  }
}