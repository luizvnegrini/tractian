import 'package:tractian/domain/domain.dart';

class Asset extends BaseEntity {
  final String? locationId;
  final String? parentId;
  final String? sensorType;
  final String? sensorId;
  final String? gatewayId;
  final Status? status;

  Asset({
    required super.id,
    required super.name,
    this.locationId,
    this.parentId,
    this.sensorType,
    this.sensorId,
    this.gatewayId,
    this.status,
  });

  bool get isComponent => sensorType != null;
}
