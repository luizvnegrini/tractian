import 'package:external_dependencies/external_dependencies.dart';

import '../../domain/domain.dart';
import '../datasource/datasource.dart';

class AssetsRepositoryImpl implements AssetsRepository {
  final AssetsDatasource datasource;

  AssetsRepositoryImpl({
    required this.datasource,
  });

  @override
  Future<Either<Exception, List<Asset>>> fetchAssets() {
    throw UnimplementedError();
  }
}
