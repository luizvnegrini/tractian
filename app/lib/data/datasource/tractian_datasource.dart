import '../../domain/domain.dart';
import '../models/models.dart';

abstract class TractianDatasource {
  Future<List<CompanyModel>> fetchCompanies();
  Future<List<AssetModel>> fetchAssets(String companyId);
  Future<List<LocationModel>> fetchLocations(String companyId);
}

class TractianDatasourceImpl implements TractianDatasource {
  final String baseUrl = 'https://fake-api.tractian.com';
  final HttpAdapter httpClient;

  TractianDatasourceImpl({required this.httpClient});

  @override
  Future<List<CompanyModel>> fetchCompanies() async {
    final response = await httpClient.get(
      '$baseUrl/companies',
    );
    final companies = response
        .map<CompanyModel>(
            (e) => CompanyModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return companies;
  }

  @override
  Future<List<AssetModel>> fetchAssets(String companyId) async {
    final response = await httpClient.get(
      '$baseUrl/companies/$companyId/assets',
    );
    final assets = response
        .map<AssetModel>((e) => AssetModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return assets;
  }

  @override
  Future<List<LocationModel>> fetchLocations(String companyId) async {
    final response = await httpClient.get(
      '$baseUrl/companies/$companyId/locations',
    );
    final locations = response
        .map<LocationModel>(
            (e) => LocationModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return locations;
  }
}
