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
  static const double nodeHeight = 40.0;
  static const double indentWidth = 16.0;
  static const double iconSize = 20.0;

  @override
  void initState() {
    super.initState();
    controller = TreeSliverController();
  }

  Widget _treeNodeBuilder(
    BuildContext context,
    TreeSliverNode node,
    AnimationStyle animationStyle,
  ) {
    final treeNode = node.content as TreeNode;
    final isParentNode = node.children.isNotEmpty;
    final border = BorderSide(
      width: 1,
      color: Colors.grey.shade300,
    );

    return TreeSliver.wrapChildToToggleNode(
      node: node,
      child: Row(
        children: [
          SizedBox(width: indentWidth * node.depth!),
          DecoratedBox(
            decoration: BoxDecoration(
              border: node.parent != null
                  ? Border(left: border, bottom: border)
                  : null,
            ),
            child: SizedBox(height: nodeHeight, width: indentWidth),
          ),
          if (isParentNode)
            SizedBox(
              width: iconSize,
              height: nodeHeight,
              child: Icon(
                node.isExpanded
                    ? Icons.keyboard_arrow_down
                    : Icons.keyboard_arrow_right,
                size: iconSize,
              ),
            ),
          AssetsNodeViewModel.getTypeIcon(treeNode.type),
          const SizedBox(width: 4),
          Text(treeNode.name),
          if (treeNode.type == NodeType.component &&
              treeNode.componentInfo?.status != null)
            AssetsNodeViewModel.getStatusIcon(treeNode.componentInfo!.status!),
        ],
      ),
    );
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
                      treeNodeBuilder: _treeNodeBuilder,
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
