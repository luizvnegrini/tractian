import 'package:external_dependencies/external_dependencies.dart';
import 'package:flutter/material.dart';

import '../../domain/domain.dart';
import '../presentation.dart';
import 'assets_page_state.dart';

class AssetsPage extends StatefulWidget {
  final String companyId;

  const AssetsPage({super.key, required this.companyId});

  @override
  State<AssetsPage> createState() => _AssetsPageState();
}

class _AssetsPageState extends State<AssetsPage> {
  late final TreeSliverController controller;

  @override
  void initState() {
    super.initState();
    controller = TreeSliverController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AssetsPageBloc(
        buildTreeNodes: GetIt.I.get(),
        fetchAssets: GetIt.I.get(),
        fetchLocations: GetIt.I.get(),
      )..fetch(widget.companyId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Assets'),
        ),
        body: BlocBuilder<AssetsPageBloc, AssetsPageState>(
          builder: (context, state) {
            return state.maybeWhen(
              loading: () => const Center(child: CircularProgressIndicator()),
              orElse: () => const Center(child: Text('No Assets Found')),
              loaded: (nodes) {
                final sliverNodes =
                    AssetsNodeViewModel.buildTreeSliverNodes(nodes);

                return CustomScrollView(
                  slivers: [
                    TreeSliver<TreeNode>(
                      tree: sliverNodes,
                      controller: controller,
                      treeNodeBuilder: (
                        BuildContext context,
                        TreeSliverNode node,
                        AnimationStyle animationStyle,
                      ) {
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => controller.toggleNode(node),
                          child: TreeSliver.defaultTreeNodeBuilder(
                            context,
                            node,
                            animationStyle,
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
