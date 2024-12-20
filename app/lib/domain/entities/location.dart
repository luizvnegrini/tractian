import 'base_entity.dart';

class Location extends BaseEntity {
  final String? parentId;

  Location({
    required super.id,
    required super.name,
    this.parentId,
  });
}
