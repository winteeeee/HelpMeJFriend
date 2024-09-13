import 'package:help_me_j_friend/persistence/entity/position.dart';
import 'package:help_me_j_friend/persistence/repository/repository.dart';
import 'package:sqflite/sqflite.dart';


class PositionRepository extends Repository<Position> {
  String tableName = "position";

  @override
  Future<List<Position>> findAll() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(tableName);

    return List.generate(maps.length, (index) {
      return Position.toEntity(maps[index]);
    });
  }

  @override
  Future<Position> findById(id) async {
    Database db = await database;
    List<Map<String, dynamic>> map = await db.query(tableName, where: "id = ?", whereArgs: [id]);
    return Position.toEntity(map[0]);
  }
}