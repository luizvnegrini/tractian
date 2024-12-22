import 'package:external_dependencies/external_dependencies.dart';
import 'package:flutter/material.dart';

import '../../core/core.dart';
import '../../domain/domain.dart';
import '../presentation.dart';
import 'companies_page_state.dart';

class CompaniesPage extends StatefulWidget {
  const CompaniesPage({super.key});

  @override
  State<CompaniesPage> createState() => _CompaniesPageState();
}

class _CompaniesPageState extends State<CompaniesPage> {
  ButtonStyle get _buttonStyle => ButtonStyle(
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(
            vertical: 24,
            horizontal: 32,
          ),
        ),
        alignment: Alignment.centerLeft,
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CompaniesPageBloc(
        fetchCompanies: GetIt.I.get<FetchCompanies>(),
      )..fetch(),
      child: Scaffold(
        appBar: AppBar(
          title: Image.asset(
            'assets/images/logo.png',
            package: 'design_system',
            height: 17,
          ),
        ),
        body: BlocBuilder<CompaniesPageBloc, CompaniesPageState>(
          builder: (context, state) {
            return SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 21, vertical: 30),
                child: state.maybeWhen(
                  orElse: () => const Center(child: Text('Loading...')),
                  error: (message) => Center(child: Text(message)),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  loaded: (companies) => ListView.separated(
                    shrinkWrap: true,
                    itemCount: companies.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final company = companies[index];
                      return ElevatedButton.icon(
                        onPressed: () => context.go(
                          Routes.assets,
                          extra: company.id,
                        ),
                        icon: Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Image.asset(
                            'assets/images/company.png',
                            package: 'design_system',
                            height: 24,
                          ),
                        ),
                        label: Text(
                          company.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: _buttonStyle,
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(height: 40),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
