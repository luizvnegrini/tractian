import 'package:external_dependencies/external_dependencies.dart';

import '../domain.dart';

abstract class FetchAssets {
  Future<Either<Exception, List<Asset>>> call(String companyId);
}

class FetchAssetsImpl implements FetchAssets {
  final TractianRepository assetsRepository;

  FetchAssetsImpl(this.assetsRepository);

  @override
  Future<Either<Exception, List<Asset>>> call(String companyId) async {
    return await assetsRepository.fetchAssets(companyId);
  }
}
