import '../../domain/domain.dart';
import '../models/models.dart';

class LocationMapper {
  static Location toEntity(LocationModel model) {
    return Location(
      id: model.id,
      name: model.name,
      parentId: model.parentId,
    );
  }
}
