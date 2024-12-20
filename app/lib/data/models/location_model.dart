import 'base_model.dart';

class LocationModel extends BaseEntity {
  final String? parentId;

  LocationModel({
    required super.id,
    required super.name,
    this.parentId,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'],
      name: json['name'],
      parentId: json['parentId'],
    );
  }
}
