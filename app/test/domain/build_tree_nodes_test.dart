import 'package:flutter_test/flutter_test.dart';
import 'package:tractian/domain/domain.dart';

void main() {
  late BuildTreeNodes buildTreeNodes;

  setUp(() {
    buildTreeNodes = BuildTreeNodesImpl();
  });

  group('BuildTreeNodes', () {
    test('should build tree with components without parent asset or location',
        () {
      final assets = [
        Asset(
          id: '1',
          name: 'Standalone Sensor A',
          sensorId: 'MTC052',
          sensorType: 'energy',
          status: Status.operating,
          gatewayId: 'QHI640',
        ),
      ];

      final result = buildTreeNodes(locations: [], assets: assets);

      expect(result.length, 1);
      expect(result.first.type, NodeType.component);
      expect(result.first.name, 'Standalone Sensor A');
      expect(result.first.componentInfo?.sensorType, SensorType.energy);
    });

    test('should build tree with asset under location', () {
      final locations = [
        Location(id: 'loc1', name: 'Factory Floor A'),
      ];
      final assets = [
        Asset(
          id: 'asset1',
          name: 'Machine XYZ',
          locationId: 'loc1',
        ),
      ];

      final result = buildTreeNodes(locations: locations, assets: assets);

      expect(result.first.type, NodeType.location);
      expect(result.first.children.first.type, NodeType.asset);
      expect(result.first.children.first.name, 'Machine XYZ');
    });

    test('should build tree with sub-locations', () {
      final locations = [
        Location(id: 'loc1', name: 'Main Building'),
        Location(id: 'loc2', name: 'Section B', parentId: 'loc1'),
      ];

      final result = buildTreeNodes(locations: locations, assets: []);

      expect(result.first.children.first.type, NodeType.location);
      expect(result.first.children.first.name, 'Section B');
    });

    test('should build tree with sub-assets', () {
      final assets = [
        Asset(id: 'asset1', name: 'Main Equipment'),
        Asset(id: 'asset2', name: 'Sub Unit 1', parentId: 'asset1'),
      ];

      final result = buildTreeNodes(locations: [], assets: assets);

      expect(result.first.type, NodeType.asset);
      expect(result.first.children.first.type, NodeType.asset);
      expect(result.first.children.first.name, 'Sub Unit 1');
    });

    test('should build tree with components under assets', () {
      final assets = [
        Asset(id: 'asset1', name: 'Processing Unit'),
        Asset(
          id: 'comp1',
          name: 'Temperature Sensor 1',
          parentId: 'asset1',
          sensorId: 'FIJ309',
          sensorType: 'vibration',
          status: Status.operating,
          gatewayId: 'FRH546',
        ),
      ];

      final result = buildTreeNodes(locations: [], assets: assets);

      expect(result.first.type, NodeType.asset);
      expect(result.first.children.first.type, NodeType.component);
      expect(result.first.children.first.name, 'Temperature Sensor 1');
      expect(result.first.children.first.componentInfo?.sensorType,
          SensorType.vibration);
    });

    test('should build tree with components under locations', () {
      final locations = [
        Location(id: 'loc1', name: 'Storage Area'),
      ];
      final assets = [
        Asset(
          id: 'comp1',
          name: 'Environment Sensor 1',
          locationId: 'loc1',
          sensorId: 'MTC052',
          sensorType: 'energy',
          status: Status.operating,
          gatewayId: 'QHI640',
        ),
      ];

      final result = buildTreeNodes(locations: locations, assets: assets);

      expect(result.first.type, NodeType.location);
      expect(result.first.children.first.type, NodeType.component);
      expect(result.first.children.first.componentInfo?.sensorType,
          SensorType.energy);
    });

    test('should build complete tree hierarchy', () {
      final locations = [
        Location(id: 'loc1', name: 'Factory Alpha'),
        Location(id: 'loc2', name: 'Production Line 1', parentId: 'loc1'),
      ];
      final assets = [
        Asset(id: 'asset1', name: 'Assembly Machine', locationId: 'loc2'),
        Asset(id: 'asset2', name: 'Robot Arm', parentId: 'asset1'),
        Asset(
          id: 'comp1',
          name: 'Motion Sensor',
          parentId: 'asset2',
          sensorId: 'FIJ309',
          sensorType: 'vibration',
          status: Status.operating,
          gatewayId: 'FRH546',
        ),
        Asset(
          id: 'comp2',
          name: 'Power Monitor',
          sensorId: 'MTC052',
          sensorType: 'energy',
          status: Status.operating,
          gatewayId: 'QHI640',
        ),
      ];

      final result = buildTreeNodes(locations: locations, assets: assets);

      expect(result.length, 2);

      final locationNode =
          result.firstWhere((node) => node.type == NodeType.location);
      expect(locationNode.children.first.type, NodeType.location);
      expect(locationNode.children.first.children.first.type, NodeType.asset);
      expect(locationNode.children.first.children.first.children.first.type,
          NodeType.asset);
      expect(
          locationNode
              .children.first.children.first.children.first.children.first.type,
          NodeType.component);

      final component = locationNode
          .children.first.children.first.children.first.children.first;
      expect(component.type, NodeType.component);
      expect(component.componentInfo?.sensorType, SensorType.vibration);

      final unlinkedComponent =
          result.firstWhere((node) => node.name == 'Power Monitor');
      expect(unlinkedComponent.type, NodeType.component);
      expect(unlinkedComponent.componentInfo?.sensorType, SensorType.energy);
    });
  });
}
