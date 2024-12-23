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

    for (var node in nodes) {
      TreeNode? matchedNode = _searchNode(node, query, filters);
      if (matchedNode != null) {
        results.add(matchedNode);
      }
    }

    return results;
  }

  TreeNode? _searchNode(
    TreeNode node,
    String query,
    List<FilterType> filters,
  ) {
    bool currentNodeMatches = _matchesSearchCriteria(node, query, filters);

    List<TreeNode> matchedChildren = [];
    for (var child in node.children) {
      TreeNode? matchedChild = _searchNode(child, query, filters);
      if (matchedChild != null) {
        matchedChildren.add(matchedChild);
      }
    }

    if (currentNodeMatches || matchedChildren.isNotEmpty) {
      return TreeNode(
        id: node.id,
        name: node.name,
        type: node.type,
        componentInfo: node.componentInfo,
        children: currentNodeMatches ? node.children : matchedChildren,
      );
    }

    return null;
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
