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
  _instance.registerSingleton<HttpAdapter>(HttpAdapterImpl(HttpClient()));

  // Datasources
  _instance.registerSingleton<TractianDatasource>(TractianDatasourceImpl(
    httpClient: _instance(),
  ));

  // Repositories
  _instance.registerSingleton<TractianRepository>(TractianRepositoryImpl(
    datasource: _instance(),
  ));

  // Usecases
  _instance.registerSingleton<FetchCompanies>(FetchDataImpl(_instance()));
}
