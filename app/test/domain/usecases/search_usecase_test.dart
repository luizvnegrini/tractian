import 'package:flutter_test/flutter_test.dart';
import 'package:tractian/domain/domain.dart';

void main() {
  late SearchUsecase searchUsecase;

  setUp(() {
    searchUsecase = SearchUsecaseImpl();
  });

  group('SearchUsecase', () {
    final testNodes = [
      TreeNode(
        id: 'loc1',
        name: 'Factory Alpha',
        type: NodeType.location,
        children: [
          TreeNode(
            id: 'asset1',
            name: 'Assembly Line',
            type: NodeType.asset,
            children: [
              TreeNode(
                id: 'comp1',
                name: 'Temperature Sensor',
                type: NodeType.component,
                componentInfo: ComponentInfo(
                  sensorId: 'SENS001',
                  sensorType: SensorType.energy,
                  status: Status.operating,
                  gatewayId: 'GW001',
                ),
                children: [],
              ),
              TreeNode(
                id: 'comp2',
                name: 'Vibration Monitor',
                type: NodeType.component,
                componentInfo: ComponentInfo(
                  sensorId: 'SENS002',
                  sensorType: SensorType.vibration,
                  status: Status.alert,
                  gatewayId: 'GW002',
                ),
                children: [],
              ),
            ],
          ),
        ],
      ),
      TreeNode(
        id: 'comp3',
        name: 'Standalone Sensor',
        type: NodeType.component,
        componentInfo: ComponentInfo(
          sensorId: 'SENS003',
          sensorType: SensorType.energy,
          status: Status.operating,
          gatewayId: 'GW003',
        ),
        children: [],
      ),
    ];

    test('should return all nodes when no query and no filters', () async {
      final result = await searchUsecase(testNodes, '', []);

      expect(result.length, testNodes.length);
    });

    test('should filter by text and maintain parent hierarchy', () async {
      final result = await searchUsecase(testNodes, 'Sensor', []);

      expect(result.length, 2); // Factory Alpha tree and Standalone Sensor
      expect(result.first.children.first.children.first.name,
          'Temperature Sensor');
      expect(result.last.name, 'Standalone Sensor');
    });

    test('should filter energy sensors and maintain parent hierarchy',
        () async {
      final result =
          await searchUsecase(testNodes, '', [FilterType.energySensor]);

      expect(result.length, 2); // Both trees contain energy sensors
      expect(
        result.first.children.first.children
            .any((node) => node.componentInfo?.sensorType == SensorType.energy),
        true,
      );
    });

    test('should filter critical status and maintain parent hierarchy',
        () async {
      final result = await searchUsecase(testNodes, '', [FilterType.critical]);

      expect(result.length, 1); // Only the tree with alert status
      expect(
        result.first.children.first.children
            .any((node) => node.componentInfo?.status == Status.alert),
        true,
      );
    });

    test('should combine text search with energy sensor filter', () async {
      final result = await searchUsecase(
        testNodes,
        'Sensor',
        [FilterType.energySensor],
      );

      expect(result.length, 2);
      for (var tree in result) {
        var hasMatch = false;
        void checkNode(TreeNode node) {
          if (node.name.contains('Sensor') &&
              node.componentInfo?.sensorType == SensorType.energy) {
            hasMatch = true;
          }
          for (var child in node.children) {
            checkNode(child);
          }
        }

        checkNode(tree);
        expect(hasMatch, true);
      }
    });

    test('should maintain complete path to matched nodes', () async {
      final result = await searchUsecase(testNodes, 'Temperature', []);

      expect(result.first.type, NodeType.location);
      expect(result.first.children.first.type, NodeType.asset);
      expect(
          result.first.children.first.children.first.type, NodeType.component);
    });

    test('should handle empty nodes list', () async {
      final result = await searchUsecase([], 'test', [FilterType.energySensor]);

      expect(result, isEmpty);
    });

    test('should handle case-insensitive search', () async {
      final result = await searchUsecase(testNodes, 'SENSOR', []);

      expect(result.length, 2);
      expect(
        result.any((node) =>
            node.name.toLowerCase().contains('sensor') ||
            node.children.any((child) =>
                child.name.toLowerCase().contains('sensor') ||
                child.children.any(
                    (comp) => comp.name.toLowerCase().contains('sensor')))),
        true,
      );
    });

    test('should combine multiple filters', () async {
      final result = await searchUsecase(
        testNodes,
        '',
        [FilterType.energySensor, FilterType.critical],
      );

      expect(result.every((node) {
        bool hasEnergySensor = false;
        bool hasCritical = false;

        void checkNode(TreeNode n) {
          if (n.type == NodeType.component) {
            if (n.componentInfo?.sensorType == SensorType.energy) {
              hasEnergySensor = true;
            }
            if (n.componentInfo?.status == Status.alert) {
              hasCritical = true;
            }
          }
          for (var child in n.children) {
            checkNode(child);
          }
        }

        checkNode(node);
        return hasEnergySensor && hasCritical;
      }), true);
    });

    test('should return complete node with all children when node matches',
        () async {
      final result = await searchUsecase(testNodes, 'Assembly Line', []);

      expect(result.length, 1);
      final assemblyNode = result.first.children.first;
      expect(assemblyNode.name, 'Assembly Line');

      // Verifica se manteve todos os filhos originais
      expect(assemblyNode.children.length, 2);
      expect(
        assemblyNode.children.map((c) => c.name).toList(),
        ['Temperature Sensor', 'Vibration Monitor'],
      );

      // Verifica se os filhos mantiveram suas informações
      final tempSensor = assemblyNode.children.first;
      expect(tempSensor.componentInfo?.sensorType, SensorType.energy);
      expect(tempSensor.componentInfo?.status, Status.operating);

      final vibSensor = assemblyNode.children.last;
      expect(vibSensor.componentInfo?.sensorType, SensorType.vibration);
      expect(vibSensor.componentInfo?.status, Status.alert);
    });
  });
}
