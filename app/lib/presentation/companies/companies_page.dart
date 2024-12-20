import 'package:external_dependencies/external_dependencies.dart';
import 'package:flutter/material.dart';

import '../presentation.dart';

class CompaniesPage extends StatefulWidget {
  const CompaniesPage({super.key});

  @override
  State<CompaniesPage> createState() => _CompaniesPageState();
}

class _CompaniesPageState extends State<CompaniesPage> {
  @override
  void initState() {
    super.initState();

    context.read<CompaniesPageBloc>().fetch();
  }

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
    return Scaffold(
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
              padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 30),
              child: state.maybeWhen(
                orElse: () => const Center(child: Text('Loading...')),
                error: (message) => Center(child: Text(message)),
                loaded: (companies) => ListView.separated(
                  shrinkWrap: true,
                  itemCount: companies.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final company = companies[index];
                    return ElevatedButton.icon(
                      onPressed: () {},
                      icon: Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Image.asset(
                          'assets/images/company.png',
                          package: 'design_system',
                          height: 24,
                        ),
                      ),
                      label: Text(company.name),
                      style: _buttonStyle,
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 40);
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
