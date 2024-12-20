import 'base_entity.dart';

class Location extends BaseEntity {
  final String? parentId;

  Location({required super.id, required super.name, this.parentId});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      name: json['name'],
      parentId: json['parentId'],
    );
  }
}
