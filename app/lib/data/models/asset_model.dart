import 'base_model.dart';

class AssetModel extends BaseEntity {
  final String? locationId;
  final String? parentId;
  final String? sensorType;
  final String? status;

  AssetModel({
    required super.id,
    required super.name,
    this.locationId,
    this.parentId,
    this.sensorType,
    this.status,
  });

  factory AssetModel.fromJson(Map<String, dynamic> json) {
    return AssetModel(
      id: json['id'],
      name: json['name'],
      locationId: json['locationId'],
      parentId: json['parentId'],
      sensorType: json['sensorType'],
      status: json['status'],
    );
  }
}
