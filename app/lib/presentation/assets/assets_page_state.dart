import '../../domain/domain.dart';

sealed class AssetsPageState {
  const AssetsPageState();

  const factory AssetsPageState.initial() = Initial;
  const factory AssetsPageState.loading() = Loading;
  const factory AssetsPageState.loaded(List<TreeNode> nodes) = Loaded;
  const factory AssetsPageState.error(String message) = Error;

  T when<T>({
    required T Function() initial,
    required T Function() loading,
    required T Function(String message) error,
    required T Function(List<TreeNode> nodes) loaded,
  }) {
    return switch (this) {
      Initial() => initial(),
      Loading() => loading(),
      Error(message: final message) => error(message),
      Loaded(nodes: final nodes) => loaded(nodes),
    };
  }

  T maybeWhen<T>({
    T Function()? initial,
    T Function()? loading,
    T Function(String message)? error,
    T Function(List<TreeNode> nodes, List<TreeNode> filteredNodes,
            List<String> activeFilters)?
        loaded,
    required T Function() orElse,
  }) {
    return switch (this) {
      Initial() => initial?.call() ?? orElse(),
      Loading() => loading?.call() ?? orElse(),
      Error(message: final message) => error?.call(message) ?? orElse(),
      Loaded(
        nodes: final nodes,
        filteredNodes: final filtered,
        activeFilters: final filters
      ) =>
        loaded?.call(nodes, filtered, filters) ?? orElse(),
    };
  }

  AssetsPageState copyWith() {
    return switch (this) {
      Initial() => const Initial(),
      Loading() => const Loading(),
      Error(message: final message) => Error(message),
      Loaded(nodes: final nodes) => Loaded(nodes),
    };
  }
}

final class Initial extends AssetsPageState {
  const Initial();
}

final class Loading extends AssetsPageState {
  const Loading();
}

final class Loaded extends AssetsPageState {
  final List<TreeNode> nodes;
  final List<TreeNode> filteredNodes;
  final List<String> activeFilters;

  const Loaded(
    this.nodes, {
    this.filteredNodes = const [],
    this.activeFilters = const [],
  });
}

final class Error extends AssetsPageState {
  final String message;

  const Error(this.message);
}
