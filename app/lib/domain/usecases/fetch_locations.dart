import 'package:external_dependencies/external_dependencies.dart';

import '../domain.dart';

abstract class FetchLocations {
  Future<Either<Exception, List<Location>>> call(String companyId);
}

class FetchLocationsImpl implements FetchLocations {
  final TractianRepository assetsRepository;

  FetchLocationsImpl(this.assetsRepository);

  @override
  Future<Either<Exception, List<Location>>> call(String companyId) async {
    return await assetsRepository.fetchLocations(companyId);
  }
}
