import '../domain.dart';

abstract class SearchUsecase {
  Future<List<TreeNode>> call(
    List<TreeNode> nodes,
    String query,
    List<FilterType> filters,
  );
}

class SearchUsecaseImpl implements SearchUsecase {
  @override
  Future<List<TreeNode>> call(
    List<TreeNode> nodes,
    String query,
    List<FilterType> filters,
  ) async {
    List<TreeNode> results = [];
    List<TreeNode> stack = List.from(nodes);

    while (stack.isNotEmpty) {
      final node = stack.removeLast();
      bool nodeMatches = _matchesSearchCriteria(node, query, filters);

      if (nodeMatches) {
        results.add(node);
        continue;
      }

      stack.addAll(node.children.reversed);
    }

    return results;
  }

  bool _matchesSearchCriteria(
    TreeNode node,
    String query,
    List<FilterType> filters,
  ) {
    bool matchesQuery =
        query.isEmpty || node.name.toLowerCase().contains(query.toLowerCase());
    if (!matchesQuery) return false;

    if (filters.isEmpty) return true;

    if (node.type != NodeType.component) return false;

    return filters.every((filter) {
      return switch (filter) {
        FilterType.energySensor =>
          node.componentInfo?.sensorType == SensorType.energy,
        FilterType.critical => node.componentInfo?.status == Status.alert,
      };
    });
  }
}
