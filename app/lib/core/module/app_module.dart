import 'package:external_dependencies/external_dependencies.dart';

import '../../presentation/presentation.dart';

class Routes {
  static String get _source => '/';
  static String get assets => '/assets';
  static String get home => _source;
}

class AppModule {
  static List<GoRoute> get routes => [
        GoRoute(
          name: 'home',
          path: Routes.home,
          builder: (_, __) => CompaniesPage(),
          routes: [
            GoRoute(
              name: 'assets',
              path: Routes.assets,
              builder: (_, state) {
                final companyId = state.extra as String;
                return AssetsPage(companyId: companyId);
              },
            ),
          ],
        ),
      ];
}
