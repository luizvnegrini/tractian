import 'dart:io';

import 'package:external_dependencies/external_dependencies.dart';

import '../adapters/adapters.dart';
import '../domain/domain.dart';

final _instance = GetIt.instance;

void setupDependencyInjectionContainer() {
  _setupDomain();
}

void _setupDomain() {
  // Adapters
  _instance.registerSingleton<HttpAdapter>(HttpAdapterImpl(HttpClient()));

  // Datasources

  // Repositories

  // Usecases
}
