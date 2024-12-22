import '../domain.dart';

class TreeNode {
  final String id;
  final String name;
  final List<TreeNode> children;
  final NodeType type;
  final ComponentInfo? componentInfo;

  TreeNode({
    required this.id,
    required this.name,
    required this.type,
    this.componentInfo,
    required this.children,
  });
}
