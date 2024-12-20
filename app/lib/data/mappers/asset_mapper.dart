import '../../domain/domain.dart';
import '../models/models.dart';

class AssetMapper {
  static Asset toEntity(AssetModel model) {
    return Asset(
      id: model.id,
      name: model.name,
      locationId: model.locationId,
      parentId: model.parentId,
      sensorType: model.sensorType,
      status: model.status,
    );
  }
}
