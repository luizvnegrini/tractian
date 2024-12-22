import 'package:flutter/material.dart';

import '../../../domain/domain.dart';
import '../../presentation.dart';

class NodeRow extends StatefulWidget {
  final FlatNode flatNode;
  final bool isExpanded;
  final bool hasChildren;
  final Function(TreeNode) onTap;
  final int depth;

  const NodeRow({
    super.key,
    required this.flatNode,
    required this.isExpanded,
    required this.hasChildren,
    required this.onTap,
    required this.depth,
  });

  @override
  State<NodeRow> createState() => _NodeRowState();
}

class _NodeRowState extends State<NodeRow> {
  static const double nodeHeight = 32.0;
  static const double levelIndent = 20.0;
  static const double iconSize = 20.0;

  @override
  Widget build(BuildContext context) {
    final node = widget.flatNode.node;

    return InkWell(
      onTap: widget.hasChildren ? () => widget.onTap(node) : null,
      child: Stack(
        children: [
          ...widget.flatNode.scopingNodes.asMap().entries.map((entry) {
            final parentDepth = entry.key;
            return Positioned(
              left: (parentDepth * levelIndent) + (iconSize / 2),
              top: 0,
              bottom: 0,
              child: Container(
                width: 1,
                color: Colors.grey.shade300,
              ),
            );
          }),
          if (widget.isExpanded)
            Positioned(
              left: (widget.depth * levelIndent) + (iconSize / 2),
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
                SizedBox(width: (widget.depth * levelIndent)),
                if (widget.hasChildren)
                  Icon(
                    widget.isExpanded
                        ? Icons.keyboard_arrow_down
                        : Icons.chevron_right,
                    size: iconSize,
                  ),
                if (!widget.hasChildren) SizedBox(width: iconSize),
                AssetsNodeViewModel.getTypeIcon(node.type),
                const SizedBox(width: 4),
                Text(node.name),
                if (node.type == NodeType.component &&
                    node.componentInfo?.status != null)
                  AssetsNodeViewModel.getStatusIcon(
                    node.componentInfo!.status!,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
