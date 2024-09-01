import 'package:flutter/material.dart';
import 'package:help_me_j_friend/persistence/entity/entity.dart';

class Plan extends Entity {
  String name;
  DateTime startDate;
  DateTime endDate;
  int accommodationPositionId;

  Plan({
    id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.accommodationPositionId,
  }) : super(id);

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'start_date': startDate.toString().split(" ")[0],
      'end_date': startDate.toString().split(" ")[0],
      'accommodation_position_id': accommodationPositionId,
    };
  }

  static Plan toEntity(map) {
    return Plan(
        id: map['id'],
        name: map['name'],
        startDate: map['start_date'],
        endDate: map['end_date'],
        accommodationPositionId: map['accommodation_position_id'],
    );
  }
}