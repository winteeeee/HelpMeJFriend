import 'package:flutter/material.dart';
import 'package:help_me_j_friend/persistence/entity/entity.dart';

class Plan extends Entity {
  String name;
  DateTime startDate;
  DateTime endDate;
  int accommodationPositionId;
  TimeOfDay planActivityStartTime;
  TimeOfDay planActivityEndTime;

  Plan({
    required id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.accommodationPositionId,
    required this.planActivityStartTime,
    required this.planActivityEndTime
  }) : super(id);

  @override
  String getTableName() {
    return "plan";
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'start_date': startDate,
      'end_date': endDate,
      'accommodation_position_id': accommodationPositionId,
      'plan_activity_start_time': planActivityStartTime,
      'plan_activity_end_time': planActivityEndTime
    };
  }

  static Plan toEntity(map) {
    return Plan(
        id: map['id'],
        name: map['name'],
        startDate: map['start_date'],
        endDate: map['end_date'],
        accommodationPositionId: map['accommodation_position_id'],
        planActivityStartTime: map['plan_activity_start_time'],
        planActivityEndTime: map['plan_activity_end_time']
    );
  }
}