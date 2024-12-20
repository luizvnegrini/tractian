import 'package:external_dependencies/external_dependencies.dart';

import '../../domain/domain.dart';
import '../data.dart';

class TractianRepositoryImpl implements TractianRepository {
  final TractianDatasource datasource;

  TractianRepositoryImpl({
    required this.datasource,
  });

  @override
  Future<Either<Exception, List<Company>>> fetchCompanies() async {
    try {
      final companies = await datasource.fetchCompanies();
      return Right(companies.map(CompanyMapper.toEntity).toList());
    } catch (e) {
      return Left(Exception(e));
    }
  }

  @override
  Future<Either<Exception, List<Asset>>> fetchAssets(String companyId) async {
    try {
      final assets = await datasource.fetchAssets(companyId);
      return Right(assets.map(AssetMapper.toEntity).toList());
    } catch (e) {
      return Left(Exception(e));
    }
  }

  @override
  Future<Either<Exception, List<Location>>> fetchLocations(
      String companyId) async {
    try {
      final locations = await datasource.fetchLocations(companyId);
      return Right(locations.map(LocationMapper.toEntity).toList());
    } catch (e) {
      return Left(Exception(e));
    }
  }
}
