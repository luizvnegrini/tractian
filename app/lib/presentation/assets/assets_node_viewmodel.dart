import 'package:flutter/widgets.dart';

import '../../domain/domain.dart';

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
      Status.operating => 'assets/images/status_operating.png',
      Status.alert => 'assets/images/status_alert.png',
    };

    return Image.asset(
      iconPath,
      package: 'design_system',
      height: 12,
      width: iconSize,
    );
  }

  static Widget getTypeIcon(NodeType type) {
    final iconPath = switch (type) {
      NodeType.location => 'assets/images/location.png',
      NodeType.asset => 'assets/images/asset.png',
      NodeType.component => 'assets/images/component.png',
    };

    return Image.asset(
      iconPath,
      package: 'design_system',
      height: iconSize,
      width: iconSize,
    );
  }
}
