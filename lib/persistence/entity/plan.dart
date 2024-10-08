import 'package:help_me_j_friend/persistence/entity/entity.dart';
import 'package:help_me_j_friend/util/utils.dart';

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
      'start_date': Utils.dateToString(startDate),
      'end_date': Utils.dateToString(endDate),
      'accommodation_position_id': accommodationPositionId,
    };
  }

  static Plan toEntity(map) {
    return Plan(
        id: map['id'],
        name: map['name'],
        startDate: DateTime.parse(map['start_date']),
        endDate: DateTime.parse(map['end_date']),
        accommodationPositionId: map['accommodation_position_id'],
    );
  }
}