import 'package:flutter/material.dart';
import 'package:help_me_j_friend/persistence/entity/entity.dart';

class Task extends Entity {
  String name;
  TimeOfDay startTime;
  TimeOfDay endTime;
  int positionId;

  Task({
    required id,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.positionId
  }) : super(id);

  @override
  String getTableName() {
    return "task";
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'start_time': startTime,
      'end_time': endTime,
      'position_id': positionId
    };
  }

  static Task toEntity(map) {
    return Task(
        id: map['id'],
        name: map['name'],
        startTime: map['start_time'],
        endTime: map['end_time'],
        positionId: map['position_id']
    );
  }
}