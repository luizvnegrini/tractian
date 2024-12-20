import '../domain.dart';

class TreeNode {
  final String id;
  final String name;
  final List<TreeNode> children;
  final Type type;
  final Status? statusIcon;

  TreeNode({
    required this.id,
    required this.name,
    required this.type,
    this.children = const [],
    this.statusIcon,
  });
}
