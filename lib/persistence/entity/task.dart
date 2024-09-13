import 'package:help_me_j_friend/persistence/entity/entity.dart';

class Task extends Entity {
  String name;
  DateTime startTime;
  DateTime endTime;
  int planId;
  int positionId;

  Task({
    id,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.planId,
    required this.positionId
  }) : super(id);

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'start_time': startTime.toString(),
      'end_time': endTime.toString(),
      'plan_id': planId,
      'position_id': positionId
    };
  }

  static Task toEntity(map) {
    return Task(
        id: map['id'],
        name: map['name'],
        startTime: DateTime.parse(map['start_time']),
        endTime: DateTime.parse(map['end_time']),
        planId: map['plan_id'],
        positionId: map['position_id']
    );
  }
}