import 'package:external_dependencies/external_dependencies.dart';

import '../domain.dart';

abstract class TractianRepository {
  Future<Either<Exception, List<Company>>> fetchCompanies();
  Future<Either<Exception, List<Location>>> fetchLocations(String companyId);
  Future<Either<Exception, List<Asset>>> fetchAssets(String companyId);
}
