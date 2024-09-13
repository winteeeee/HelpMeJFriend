import 'package:help_me_j_friend/persistence/entity/plan.dart';
import 'package:help_me_j_friend/persistence/repository/repository.dart';
import 'package:sqflite/sqflite.dart';

class PlanRepository extends Repository<Plan> {
  String tableName = "plan";

  @override
  Future<List<Plan>> findAll() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(tableName);

    return List.generate(maps.length, (index) {
      return Plan.toEntity(maps[index]);
    });
  }

  @override
  Future<Plan> findById(id) async {
    Database db = await database;
    List<Map<String, dynamic>> map = await db.query(tableName, where: "id = ?", whereArgs: [id]);
    return Plan.toEntity(map[0]);
  }

  Future<List<Plan>> findAllOrderByStartDate() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.rawQuery("""
    SELECT * FROM Plan ORDER BY start_date
    """);

    return List.generate(maps.length, (index) {
      return Plan.toEntity(maps[index]);
    });
  }

  Future<bool> isDuplicated(int? id, startDate, endDate) async {
    Database db = await database;
    List<Map<String, dynamic>> maps;
    if (id != null) {
      maps = await db.rawQuery("""
        SELECT *
        FROM Plan
        WHERE id != $id AND (('$startDate' < start_date AND end_date < '$endDate')
          OR ('$startDate' < start_date AND start_date < '$endDate')
          OR ('$startDate' < end_date AND end_date < '$endDate')
          OR (start_date < '$startDate' AND '$endDate' < end_date))
    """);
    } else {
      maps = await db.rawQuery("""
        SELECT *
        FROM Plan
        WHERE ('$startDate' < start_date AND end_date < '$endDate')
          OR ('$startDate' < start_date AND start_date < '$endDate')
          OR ('$startDate' < end_date AND end_date < '$endDate')
          OR (start_date < '$startDate' AND '$endDate' < end_date)
    """);
    }

    return maps.isNotEmpty;
  }
}