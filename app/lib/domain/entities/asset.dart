import 'base_entity.dart';

class Asset extends BaseEntity {
  final String? locationId;
  final String? parentId;
  final String? sensorType;
  final String? status;

  Asset({
    required super.id,
    required super.name,
    this.locationId,
    this.parentId,
    this.sensorType,
    this.status,
  });

  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset(
      id: json['id'],
      name: json['name'],
      locationId: json['locationId'],
      parentId: json['parentId'],
      sensorType: json['sensorType'],
      status: json['status'],
    );
  }
}
