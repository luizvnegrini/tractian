import '../../domain/domain.dart';
import '../models/models.dart';

class CompanyMapper {
  static Company toEntity(CompanyModel model) {
    return Company(
      id: model.id,
      name: model.name,
    );
  }
}
