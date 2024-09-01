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
}