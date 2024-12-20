import 'package:external_dependencies/external_dependencies.dart';
import 'package:flutter/material.dart';

import 'app_module.dart';

final GoRouter router = GoRouter(
  navigatorKey: GlobalKey<NavigatorState>(),
  routes: <RouteBase>[
    ...AppModule.routes,
  ],
);
