import 'package:tractian/domain/domain.dart';

class Asset extends BaseEntity {
  final String? locationId;
  final String? parentId;
  final String? sensorType;
  final Status? status;

  Asset({
    required super.id,
    required super.name,
    this.locationId,
    this.parentId,
    this.sensorType,
    this.status,
  });
}
