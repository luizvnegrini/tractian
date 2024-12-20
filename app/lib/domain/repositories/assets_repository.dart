import 'package:external_dependencies/external_dependencies.dart';

import '../domain.dart';

abstract class AssetsRepository {
  Future<Either<Exception, List<Asset>>> fetchAssets();
}
