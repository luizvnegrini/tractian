import 'package:flutter/widgets.dart';

class AssetsPage extends StatelessWidget {
  final String companyId;

  const AssetsPage({super.key, required this.companyId});

  @override
  Widget build(BuildContext context) {
    return Center(child: const Text('Assets'));
  }
}
