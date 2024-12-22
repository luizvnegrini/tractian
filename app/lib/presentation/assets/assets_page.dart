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
  final Map<String, bool> _expandedNodes = {};
  static const double nodeHeight = 32.0;
  static const double baseIndent = 16.0;
  static const double levelIndent = 20.0;
  static const double iconSize = 20.0;

  void _toggleNode(TreeNode node) {
    setState(() {
      _expandedNodes[node.id] = !(_expandedNodes[node.id] ?? false);
    });
  }

  List<_FlatNode> _buildFlattenedList(List<TreeNode> nodes,
      [int depth = 0, List<TreeNode> scopingNodes = const []]) {
    List<_FlatNode> flattened = [];

    for (var i = 0; i < nodes.length; i++) {
      final node = nodes[i];
      final hasChildren = node.children.isNotEmpty;
      final isExpanded = _expandedNodes[node.id] ?? false;

      flattened.add(_FlatNode(
        node,
        depth,
        List.from(scopingNodes),
        hasChildren && isExpanded,
      ));

      if (isExpanded) {
        var newScopingNodes = List<TreeNode>.from(scopingNodes);
        newScopingNodes.add(node);
        flattened.addAll(_buildFlattenedList(
          node.children,
          depth + 1,
          newScopingNodes,
        ));
      }
    }

    return flattened;
  }

  Widget _buildNodeRow(_FlatNode flatNode) {
    final node = flatNode.node;
    final depth = flatNode.depth;
    final hasChildren = node.children.isNotEmpty;
    final isExpanded = _expandedNodes[node.id] ?? false;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: hasChildren ? () => _toggleNode(node) : null,
        child: Stack(
          children: [
            // Linhas de escopo (dos pais)
            ...flatNode.scopingNodes.asMap().entries.map((entry) {
              final parentDepth = entry.key;
              return Positioned(
                left: baseIndent + (parentDepth * levelIndent) + (iconSize / 2),
                top: 0,
                bottom: 0,
                child: Container(
                  width: 1,
                  color: Colors.grey.shade300,
                ),
              );
            }),
            // Linha do nó atual quando expandido
            if (isExpanded)
              Positioned(
                left: baseIndent + (depth * levelIndent) + (iconSize / 2),
                top: nodeHeight,
                bottom: 0,
                child: Container(
                  width: 1,
                  color: Colors.grey.shade300,
                ),
              ),
            SizedBox(
              height: nodeHeight,
              child: Row(
                children: [
                  SizedBox(width: baseIndent + (depth * levelIndent)),
                  if (hasChildren)
                    Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_right,
                      size: iconSize,
                    ),
                  if (!hasChildren) SizedBox(width: iconSize),
                  const SizedBox(width: 4),
                  AssetsNodeViewModel.getTypeIcon(node.type),
                  const SizedBox(width: 4),
                  Text(node.name),
                  if (node.type == NodeType.component &&
                      node.componentInfo?.status != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: AssetsNodeViewModel.getStatusIcon(
                          node.componentInfo!.status!),
                    ),
                ],
              ),
            ),
          ],
        ),
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
                final flattenedNodes = _buildFlattenedList(nodes);

                return ListView.builder(
                  itemCount: flattenedNodes.length,
                  itemBuilder: (context, index) {
                    final flatNode = flattenedNodes[index];
                    return _buildNodeRow(flatNode);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _FlatNode {
  final TreeNode node;
  final int depth;
  final List<TreeNode> scopingNodes;
  final bool isExpanded;

  _FlatNode(
    this.node,
    this.depth,
    this.scopingNodes,
    this.isExpanded,
  );
}
