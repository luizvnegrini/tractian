import 'base_model.dart';

class AssetModel extends BaseEntity {
  final String? locationId;
  final String? parentId;
  final String? sensorType;
  final String? sensorId;
  final String? gatewayId;
  final String? status;

  AssetModel({
    required super.id,
    required super.name,
    this.locationId,
    this.parentId,
    this.sensorType,
    this.sensorId,
    this.gatewayId,
    this.status,
  });

  factory AssetModel.fromJson(Map<String, dynamic> json) {
    return AssetModel(
      id: json['id'],
      name: json['name'],
      locationId: json['locationId'],
      parentId: json['parentId'],
      sensorType: json['sensorType'],
      sensorId: json['sensorId'],
      gatewayId: json['gatewayId'],
      status: json['status'],
    );
  }
}
