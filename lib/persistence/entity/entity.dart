abstract class Entity {
  int id;

  Entity(this.id);

  String getTableName();
  Map<String, dynamic> toMap();
}