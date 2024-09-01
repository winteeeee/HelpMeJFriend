import 'package:help_me_j_friend/persistence/entity/entity.dart';

class Position extends Entity {
  String name;
  double latitude;
  double longitude;

  Position({
    id,
    required this.name,
    required this.latitude,
    required this.longitude
  }) : super(id);

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude
    };
  }

  static Position toEntity(map) {
    return Position(
        id: map['id'],
        name: map['name'],
        latitude: map['latitude'],
        longitude: map['longitude']
    );
  }
}