import '../domain.dart';

abstract class SearchUsecase {
  Future<List<TreeNode>> call(List<TreeNode> nodes, String query);
}

class SearchUsecaseImpl implements SearchUsecase {
  @override
  Future<List<TreeNode>> call(List<TreeNode> nodes, String query) async {
    List<TreeNode> results = [];
    List<TreeNode> stack = List.from(nodes);

    while (stack.isNotEmpty) {
      final node = stack.removeLast();
      bool nodeMatches = node.name.toLowerCase().contains(query);

      if (nodeMatches) {
        results.add(node);
        continue;
      }

      stack.addAll(node.children.reversed);
    }

    return results;
  }
}
