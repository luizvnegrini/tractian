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
      sensorId: model.sensorId,
      gatewayId: model.gatewayId,
      status: switch (model.status) {
        'critical' => Status.critical,
        'operating' => Status.operating,
        _ => null,
      },
    );
  }
}
