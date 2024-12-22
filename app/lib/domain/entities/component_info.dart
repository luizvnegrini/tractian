import '../domain.dart';

class ComponentInfo {
  final String sensorId;
  final SensorType sensorType;
  final Status? status;
  final String gatewayId;

  ComponentInfo({
    required this.sensorId,
    required this.sensorType,
    this.status,
    required this.gatewayId,
  });
}
