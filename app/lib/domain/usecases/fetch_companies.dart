import 'package:external_dependencies/external_dependencies.dart';

import '../domain.dart';

abstract class FetchCompanies {
  Future<Either<Exception, List<Company>>> call();
}

class FetchDataImpl implements FetchCompanies {
  final TractianRepository assetsRepository;

  FetchDataImpl(this.assetsRepository);

  @override
  Future<Either<Exception, List<Company>>> call() async {
    return await assetsRepository.fetchCompanies();
  }
}
