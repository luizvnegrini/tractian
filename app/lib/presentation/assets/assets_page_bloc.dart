import 'package:external_dependencies/external_dependencies.dart';
import 'package:tractian/core/core.dart';

import '../../domain/domain.dart';
import 'assets_page_state.dart';

class AssetsPageBloc extends BlocBase<AssetsPageState> {
  final FetchAssets fetchAssets;
  final FetchLocations fetchLocations;
  final BuildTreeNodes buildTreeNodes;

  AssetsPageBloc({
    required this.fetchAssets,
    required this.fetchLocations,
    required this.buildTreeNodes,
  }) : super(const AssetsPageState.initial());

  Future<void> fetch(String companyId) async {
    emit(const AssetsPageState.loading());

    final result = await Future.wait([
      fetchAssets(companyId),
      fetchLocations(companyId),
    ]);

    final assetsResult = result[0];
    final locationsResult = result[1];

    if (result.any((r) => r.isLeft())) {
      emit(AssetsPageState.error('Error fetching data'));
      return;
    }

    final assets = assetsResult.toRight() as List<Asset>;
    final locations = locationsResult.toRight() as List<Location>;

    final treeNodes = buildTreeNodes(
      locations: locations,
      assets: assets,
    );

    emit(AssetsPageState.loaded(treeNodes));
  }
}
