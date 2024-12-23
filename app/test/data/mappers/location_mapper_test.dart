import 'package:flutter_test/flutter_test.dart';
import 'package:tractian/data/mappers/mappers.dart';
import 'package:tractian/data/models/models.dart';

void main() {
  group('LocationMapper', () {
    test('should map root location correctly', () {
      final model = LocationModel(
        id: '65674204664c41001e91ecb4',
        name: 'PRODUCTION AREA - RAW MATERIAL',
        parentId: null,
      );

      final result = LocationMapper.toEntity(model);

      expect(result.id, '65674204664c41001e91ecb4');
      expect(result.name, 'PRODUCTION AREA - RAW MATERIAL');
      expect(result.parentId, null);
    });

    test('should map sub-location correctly', () {
      final model = LocationModel(
        id: '656a07b3f2d4a1001e2144bf',
        name: 'CHARCOAL STORAGE SECTOR',
        parentId: '65674204664c41001e91ecb4',
      );

      final result = LocationMapper.toEntity(model);

      expect(result.id, '656a07b3f2d4a1001e2144bf');
      expect(result.name, 'CHARCOAL STORAGE SECTOR');
      expect(result.parentId, '65674204664c41001e91ecb4');
    });

    test('should preserve location name exactly as received', () {
      final model = LocationModel(
        id: '1',
        name: 'SECTOR A-123',
        parentId: null,
      );

      final result = LocationMapper.toEntity(model);

      expect(result.name, 'SECTOR A-123');
    });

    test('should handle location name with special characters', () {
      final model = LocationModel(
        id: '1',
        name: 'Storage & Processing - Unit #2',
        parentId: null,
      );

      final result = LocationMapper.toEntity(model);

      expect(result.name, 'Storage & Processing - Unit #2');
    });

    test('should map multiple locations independently', () {
      final models = [
        LocationModel(
          id: 'loc1',
          name: 'Main Building',
          parentId: null,
        ),
        LocationModel(
          id: 'loc2',
          name: 'Section A',
          parentId: 'loc1',
        ),
        LocationModel(
          id: 'loc3',
          name: 'Section B',
          parentId: 'loc1',
        ),
      ];

      final results = models.map(LocationMapper.toEntity).toList();

      expect(results.length, 3);
      expect(results[0].id, 'loc1');
      expect(results[0].name, 'Main Building');
      expect(results[0].parentId, null);

      expect(results[1].id, 'loc2');
      expect(results[1].name, 'Section A');
      expect(results[1].parentId, 'loc1');

      expect(results[2].id, 'loc3');
      expect(results[2].name, 'Section B');
      expect(results[2].parentId, 'loc1');
    });

    test('should handle deep sub-locations', () {
      final models = [
        LocationModel(
          id: 'loc1',
          name: 'Factory',
          parentId: null,
        ),
        LocationModel(
          id: 'loc2',
          name: 'Building A',
          parentId: 'loc1',
        ),
        LocationModel(
          id: 'loc3',
          name: 'Floor 1',
          parentId: 'loc2',
        ),
        LocationModel(
          id: 'loc4',
          name: 'Section 1A',
          parentId: 'loc3',
        ),
      ];

      final results = models.map(LocationMapper.toEntity).toList();

      // Verifica a cadeia de parentId
      expect(results[3].parentId, 'loc3');
      expect(results[2].parentId, 'loc2');
      expect(results[1].parentId, 'loc1');
      expect(results[0].parentId, null);
    });
  });
}
