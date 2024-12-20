import '../../domain/domain.dart';
import '../models/models.dart';

abstract class AssetsDatasource {
  Future<List<AssetModel>> fetch();
}

class AssetsDatasourceImpl implements AssetsDatasource {
  final HttpAdapter httpClient;

  AssetsDatasourceImpl({required this.httpClient});

  @override
  Future<List<AssetModel>> fetch() async {
    final response = await httpClient.get(
      'https://github.com/tractian/challenges/blob/main/mobile/fake-api.tractian.com',
    );

    return response;
  }
}
