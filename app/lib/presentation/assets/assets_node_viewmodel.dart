import 'package:design_system/design_system.dart';
import 'package:flutter/widgets.dart';

import '../../domain/domain.dart';

class FlatNode {
  final TreeNode node;
  final int depth;
  final List<TreeNode> scopingNodes;
  final bool isExpanded;

  FlatNode(
    this.node,
    this.depth,
    this.scopingNodes,
    this.isExpanded,
  );
}

class AssetsNodeViewModel {
  static const iconSize = 22.0;

  static List<TreeSliverNode<TreeNode>> buildTreeSliverNodes(
      List<TreeNode> nodes) {
    return nodes.map((node) => _buildTreeSliverNode(node)).toList();
  }

  static TreeSliverNode<TreeNode> _buildTreeSliverNode(TreeNode node) {
    final children =
        node.children.map((child) => _buildTreeSliverNode(child)).toList();

    return TreeSliverNode(
      node,
      children: children,
    );
  }

  static Widget getStatusIcon(Status status) {
    final iconPath = switch (status) {
      Status.operating => 'status_operating.png',
      Status.alert => 'status_alert.png',
    };

    return ImageAsset(
      iconPath,
      height: 12,
      width: iconSize,
    );
  }

  static Widget getTypeIcon(NodeType type) {
    final iconPath = switch (type) {
      NodeType.location => 'location.png',
      NodeType.asset => 'asset.png',
      NodeType.component => 'component.png',
    };

    return ImageAsset(
      iconPath,
      height: iconSize,
      width: iconSize,
    );
  }
}
