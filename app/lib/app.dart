import 'package:design_system/design_system.dart';
import 'package:external_dependencies/external_dependencies.dart';
import 'package:flutter/material.dart';

import 'core/core.dart';
import 'domain/domain.dart';
import 'presentation/presentation.dart';

class Startup {
  static Future<void> run() async {
    WidgetsFlutterBinding.ensureInitialized();

    setupDependencyInjectionContainer();

    runApp(_App());
    FlutterError.demangleStackTrace = (StackTrace stack) {
      if (stack is Trace) return stack.vmTrace;
      if (stack is Chain) return stack.toTrace().vmTrace;
      return stack;
    };
  }
}

class _App extends StatelessWidget {
  const _App();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: F.title,
      theme: buildTheme(),
      home: BlocProvider(
        create: (context) => CompaniesPageBloc(
          fetchData: GetIt.I.get<FetchCompanies>(),
        ),
        child: CompaniesPage(),
      ),
    );
  }
}
