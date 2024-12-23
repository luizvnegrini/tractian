import 'package:flutter_test/flutter_test.dart';
import 'package:tractian/data/mappers/mappers.dart';
import 'package:tractian/data/models/models.dart';
import 'package:tractian/domain/domain.dart';

void main() {
  group('AssetMapper', () {
    test('should map component with energy sensor correctly', () {
      final model = AssetModel(
        id: '656734821f4664001f296973',
        name: 'Fan - External',
        parentId: null,
        sensorId: 'MTC052',
        sensorType: 'energy',
        status: 'operating',
        gatewayId: 'QHI640',
        locationId: null,
      );

      final result = AssetMapper.toEntity(model);

      expect(result.id, '656734821f4664001f296973');
      expect(result.name, 'Fan - External');
      expect(result.parentId, null);
      expect(result.sensorId, 'MTC052');
      expect(result.sensorType, 'energy');
      expect(result.status, Status.operating);
      expect(result.gatewayId, 'QHI640');
      expect(result.locationId, null);
    });

    test('should map asset with location correctly', () {
      final model = AssetModel(
        id: '656a07bbf2d4a1001e2144c2',
        name: 'CONVEYOR BELT ASSEMBLY',
        locationId: '656a07b3f2d4a1001e2144bf',
        parentId: null,
        sensorId: null,
        sensorType: null,
        status: null,
        gatewayId: null,
      );

      final result = AssetMapper.toEntity(model);

      expect(result.id, '656a07bbf2d4a1001e2144c2');
      expect(result.name, 'CONVEYOR BELT ASSEMBLY');
      expect(result.locationId, '656a07b3f2d4a1001e2144bf');
      expect(result.parentId, null);
      expect(result.sensorId, null);
      expect(result.sensorType, null);
      expect(result.status, null);
      expect(result.gatewayId, null);
    });

    test('should map sub-asset correctly', () {
      final model = AssetModel(
        id: '656a07c3f2d4a1001e2144c5',
        name: 'MOTOR TC01',
        parentId: '656a07bbf2d4a1001e2144c2',
        locationId: null,
        sensorId: null,
        sensorType: null,
        status: null,
        gatewayId: null,
      );

      final result = AssetMapper.toEntity(model);

      expect(result.id, '656a07c3f2d4a1001e2144c5');
      expect(result.name, 'MOTOR TC01');
      expect(result.parentId, '656a07bbf2d4a1001e2144c2');
      expect(result.locationId, null);
      expect(result.sensorId, null);
      expect(result.sensorType, null);
      expect(result.status, null);
      expect(result.gatewayId, null);
    });

    test('should map component with vibration sensor correctly', () {
      final model = AssetModel(
        id: '656a07cdc50ec9001e84167b',
        name: 'MOTOR RT',
        parentId: '656a07c3f2d4a1001e2144c5',
        sensorId: 'FIJ309',
        sensorType: 'vibration',
        status: 'alert',
        gatewayId: 'FRH546',
        locationId: null,
      );

      final result = AssetMapper.toEntity(model);

      expect(result.id, '656a07cdc50ec9001e84167b');
      expect(result.name, 'MOTOR RT');
      expect(result.parentId, '656a07c3f2d4a1001e2144c5');
      expect(result.sensorId, 'FIJ309');
      expect(result.sensorType, 'vibration');
      expect(result.status, Status.alert);
      expect(result.gatewayId, 'FRH546');
      expect(result.locationId, null);
    });

    test('should handle unknown status correctly', () {
      final model = AssetModel(
        id: '1',
        name: 'Test Asset',
        status: 'unknown_status',
        sensorId: 'SENS001',
        sensorType: 'energy',
        gatewayId: 'GW001',
        parentId: null,
        locationId: null,
      );

      final result = AssetMapper.toEntity(model);

      expect(result.status, null);
    });

    test('should handle null status correctly', () {
      final model = AssetModel(
        id: '1',
        name: 'Test Asset',
        status: null,
        sensorId: null,
        sensorType: null,
        gatewayId: null,
        parentId: null,
        locationId: null,
      );

      final result = AssetMapper.toEntity(model);

      expect(result.status, null);
    });
  });
}
