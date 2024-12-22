import 'package:external_dependencies/external_dependencies.dart';
import 'package:tractian/core/core.dart';

import '../../domain/domain.dart';
import 'assets_page_state.dart';

class AssetsPageBloc extends BlocBase<AssetsPageState> {
  final FetchAssets fetchAssets;
  final FetchLocations fetchLocations;
  final BuildTreeNodes buildTreeNodes;
  final SearchUsecase searchUsecase;
  List<TreeNode> _allNodes = [];

  AssetsPageBloc({
    required this.fetchAssets,
    required this.fetchLocations,
    required this.buildTreeNodes,
    required this.searchUsecase,
  }) : super(const AssetsPageState.initial());

  Future<void> fetch(String companyId) async {
    emit(const AssetsPageState.loading());

    final result = await Future.wait([
      fetchAssets(companyId),
      fetchLocations(companyId),
    ]);

    if (result.any((r) => r.isLeft())) {
      emit(const AssetsPageState.error('Error fetching data'));
      return;
    }

    final assets = result[0].toRight() as List<Asset>;
    final locations = result[1].toRight() as List<Location>;

    _allNodes = buildTreeNodes(
      locations: locations,
      assets: assets,
    );

    emit(Loaded(_allNodes));
  }

  Future<void> search(String query) async {
    emit(const AssetsPageState.loading());

    await Future.delayed(
      Duration(milliseconds: 250),
    );

    if (query.isEmpty) {
      emit(Loaded(_allNodes));
      return;
    }

    final filteredNodes = await searchUsecase(_allNodes, query.toLowerCase());
    emit(Loaded(_allNodes, filteredNodes: filteredNodes));
  }
}
