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
  final Map<String, String> _parentMap = {};

  void _toggleNode(TreeNode node) {
    setState(() {
      _expandedNodes[node.id] = !(_expandedNodes[node.id] ?? false);
    });
  }

  List<_FlatNode> _buildFlattenedList(List<TreeNode> nodes,
      [int depth = 0, String? parentId]) {
    List<_FlatNode> flattened = [];

    for (var node in nodes) {
      if (parentId != null) {
        _parentMap[node.id] = parentId;
      }
      flattened.add(_FlatNode(node, depth));
      if (_expandedNodes[node.id] ?? false) {
        flattened
            .addAll(_buildFlattenedList(node.children, depth + 1, node.id));
      }
    }

    return flattened;
  }

  Widget _buildNodeRow(_FlatNode flatNode, bool isLastChild) {
    final node = flatNode.node;
    final depth = flatNode.depth;
    final hasChildren = node.children.isNotEmpty;
    final isExpanded = _expandedNodes[node.id] ?? false;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: hasChildren ? () => _toggleNode(node) : null,
        child: SizedBox(
          height: 40,
          child: Row(
            children: [
              ...List.generate(depth, (index) {
                final parentId =
                    _findParentIdAtDepth(node.id, depth - index - 1);
                final showLine = parentId != null &&
                    _hasChildren(parentId) &&
                    (_expandedNodes[parentId] ?? false);
                return SizedBox(
                  width: 20,
                  height: 40,
                  child: showLine
                      ? Center(
                          child: Container(
                            width: 1,
                            height: 40,
                            color: Colors.grey.shade300,
                          ),
                        )
                      : null,
                );
              }),
              if (hasChildren)
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_down
                      : Icons.keyboard_arrow_right,
                  size: 20,
                ),
              if (node.type == NodeType.component &&
                  node.componentInfo?.status != null)
                AssetsNodeViewModel.getStatusIcon(node.componentInfo!.status!),
              AssetsNodeViewModel.getTypeIcon(node.type),
              const SizedBox(width: 8),
              Text(node.name),
            ],
          ),
        ),
      ),
    );
  }

  String? _findParentIdAtDepth(String nodeId, int targetDepth) {
    String? currentId = nodeId;
    int currentDepth = _getNodeDepth(nodeId);

    while (currentId != null && currentDepth > targetDepth) {
      currentId = _parentMap[currentId];
      currentDepth--;
    }

    return currentId;
  }

  int _getNodeDepth(String nodeId) {
    int depth = 0;
    String? currentId = nodeId;

    while (_parentMap.containsKey(currentId)) {
      depth++;
      currentId = _parentMap[currentId];
    }

    return depth;
  }

  bool _hasChildren(String nodeId) {
    return _parentMap.containsValue(nodeId);
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
                _parentMap.clear();
                final flattenedNodes = _buildFlattenedList(nodes);

                return ListView.builder(
                  itemCount: flattenedNodes.length,
                  itemBuilder: (context, index) {
                    final flatNode = flattenedNodes[index];
                    final isLastChild = index == flattenedNodes.length - 1 ||
                        flattenedNodes[index + 1].depth <= flatNode.depth;
                    return _buildNodeRow(flatNode, isLastChild);
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

  _FlatNode(this.node, this.depth);
}
