import 'package:flutter_test/flutter_test.dart';
import 'package:tractian/data/mappers/mappers.dart';
import 'package:tractian/data/models/models.dart';

void main() {
  group('CompanyMapper', () {
    test('should map company model to entity correctly', () {
      final model = CompanyModel(
        id: '65674204664c41001e91ecb4',
        name: 'Company Test',
      );

      final result = CompanyMapper.toEntity(model);

      expect(result.id, '65674204664c41001e91ecb4');
      expect(result.name, 'Company Test');
    });

    test('should preserve company name exactly as received', () {
      final model = CompanyModel(
        id: '1',
        name: 'COMPANY NAME IN CAPS',
      );

      final result = CompanyMapper.toEntity(model);

      expect(result.name, 'COMPANY NAME IN CAPS');
    });

    test('should handle company name with special characters', () {
      final model = CompanyModel(
        id: '1',
        name: 'Company & Sons - Branch #1',
      );

      final result = CompanyMapper.toEntity(model);

      expect(result.name, 'Company & Sons - Branch #1');
    });

    test('should map multiple companies independently', () {
      final models = [
        CompanyModel(id: '1', name: 'Company A'),
        CompanyModel(id: '2', name: 'Company B'),
        CompanyModel(id: '3', name: 'Company C'),
      ];

      final results = models.map(CompanyMapper.toEntity).toList();

      expect(results.length, 3);
      expect(results[0].id, '1');
      expect(results[0].name, 'Company A');
      expect(results[1].id, '2');
      expect(results[1].name, 'Company B');
      expect(results[2].id, '3');
      expect(results[2].name, 'Company C');
    });
  });
}
