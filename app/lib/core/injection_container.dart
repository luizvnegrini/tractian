import 'dart:io';

import 'package:external_dependencies/external_dependencies.dart';

import '../adapters/adapters.dart';
import '../data/data.dart';
import '../domain/domain.dart';

final _instance = GetIt.instance;

void setupDependencyInjectionContainer() {
  _setupDomain();
}

void _setupDomain() {
  // Adapters
  _instance.registerFactory<HttpAdapter>(() => HttpAdapterImpl(HttpClient()));

  // Datasources
  _instance.registerFactory<TractianDatasource>(() => TractianDatasourceImpl(
        httpClient: _instance(),
      ));

  // Repositories
  _instance.registerFactory<TractianRepository>(() => TractianRepositoryImpl(
        datasource: _instance(),
      ));

  // Usecases
  _instance
    ..registerFactory<BuildTreeNodes>(() => BuildTreeNodesImpl())
    ..registerFactory<FetchCompanies>(() => FetchDataImpl(_instance()))
    ..registerFactory<FetchAssets>(() => FetchAssetsImpl(_instance()))
    ..registerFactory<FetchLocations>(() => FetchLocationsImpl(_instance()));
}
