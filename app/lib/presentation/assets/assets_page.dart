import 'dart:async';

import 'package:design_system/design_system.dart';
import 'package:external_dependencies/external_dependencies.dart';
import 'package:flutter/material.dart';

import '../../domain/domain.dart';
import '../presentation.dart';
import 'assets_page_state.dart';

class AssetsPage extends StatefulWidget {
  final String companyId;

  const AssetsPage({super.key, required this.companyId});

  @override
  State<AssetsPage> createState() => _AssetsPageState();
}

class _AssetsPageState extends State<AssetsPage> {
  late final AssetsPageBloc _bloc;
  final Map<String, bool> _expandedNodes = {};
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  Timer? _debounceTimer;
  static const double nodeHeight = 32.0;
  static const double levelIndent = 20.0;
  static const double iconSize = 20.0;
  final List<FilterType> _selectedFilters = [];

  @override
  void initState() {
    super.initState();
    _bloc = AssetsPageBloc(
      buildTreeNodes: GetIt.I.get(),
      fetchAssets: GetIt.I.get(),
      fetchLocations: GetIt.I.get(),
      searchUsecase: GetIt.I.get(),
    )..fetch(widget.companyId);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _debounceTimer?.cancel();
    _bloc.close();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(seconds: 2), () {
      _bloc.search(query, _selectedFilters);
    });
  }

  void _onFilterSelected(FilterType filter) {
    setState(() {
      if (_selectedFilters.contains(filter)) {
        _selectedFilters.remove(filter);
      } else {
        _selectedFilters.add(filter);
      }
    });
    _bloc.search(_searchController.text, _selectedFilters);
  }

  Widget _buildSearchBar() {
    final isEnergySensorSelected =
        _selectedFilters.contains(FilterType.energySensor);
    final isCriticalSelected = _selectedFilters.contains(FilterType.critical);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(
            height: 36,
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              decoration: InputDecoration(
                hintText: 'Buscar Ativo ou Local',
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (value) => _onSearchChanged(value),
              onSubmitted: (value) {
                _debounceTimer?.cancel();
                _bloc.search(value, _selectedFilters);
                _searchFocusNode.requestFocus();
              },
              textInputAction: TextInputAction.search,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _FilterChip(
                label: 'Sensor de Energia',
                iconPath: 'filter_bolt.png',
                isSelected: isEnergySensorSelected,
                onSelected: (_) => _onFilterSelected(FilterType.energySensor),
              ),
              const SizedBox(width: 8),
              _FilterChip(
                label: 'Crítico',
                iconPath: 'filter_exclamation.png',
                isSelected: isCriticalSelected,
                onSelected: (_) => _onFilterSelected(FilterType.critical),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _toggleNode(TreeNode node) {
    setState(() {
      _expandedNodes[node.id] = !(_expandedNodes[node.id] ?? false);
    });
  }

  List<_FlatNode> _buildFlattenedList(List<TreeNode> nodes,
      [int depth = 0, List<TreeNode> scopingNodes = const []]) {
    List<_FlatNode> flattened = [];

    for (var i = 0; i < nodes.length; i++) {
      final node = nodes[i];
      final hasChildren = node.children.isNotEmpty;
      final isExpanded = _expandedNodes[node.id] ?? false;

      flattened.add(_FlatNode(
        node,
        depth,
        List.from(scopingNodes),
        hasChildren && isExpanded,
      ));

      if (isExpanded) {
        var newScopingNodes = List<TreeNode>.from(scopingNodes);
        newScopingNodes.add(node);
        flattened.addAll(_buildFlattenedList(
          node.children,
          depth + 1,
          newScopingNodes,
        ));
      }
    }

    return flattened;
  }

  Widget _buildNodeRow(_FlatNode flatNode) {
    final node = flatNode.node;
    final depth = flatNode.depth;
    final hasChildren = node.children.isNotEmpty;
    final isExpanded = _expandedNodes[node.id] ?? false;

    return InkWell(
      onTap: hasChildren ? () => _toggleNode(node) : null,
      child: Stack(
        children: [
          ...flatNode.scopingNodes.asMap().entries.map((entry) {
            final parentDepth = entry.key;
            return Positioned(
              left: (parentDepth * levelIndent) + (iconSize / 2),
              top: 0,
              bottom: 0,
              child: Container(
                width: 1,
                color: Colors.grey.shade300,
              ),
            );
          }),
          if (isExpanded)
            Positioned(
              left: (depth * levelIndent) + (iconSize / 2),
              top: nodeHeight,
              bottom: 0,
              child: Container(
                width: 1,
                color: Colors.grey.shade300,
              ),
            ),
          SizedBox(
            height: nodeHeight,
            child: Row(
              children: [
                SizedBox(width: (depth * levelIndent)),
                if (hasChildren)
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_down
                        : Icons.chevron_right,
                    size: iconSize,
                  ),
                if (!hasChildren) SizedBox(width: iconSize),
                AssetsNodeViewModel.getTypeIcon(node.type),
                const SizedBox(width: 4),
                Text(node.name),
                if (node.type == NodeType.component &&
                    node.componentInfo?.status != null)
                  AssetsNodeViewModel.getStatusIcon(
                      node.componentInfo!.status!),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Assets'),
        ),
        body: SafeArea(
          child: Column(
            children: [
              _buildSearchBar(),
              Divider(),
              Expanded(
                child: BlocBuilder<AssetsPageBloc, AssetsPageState>(
                  builder: (context, state) {
                    return state.maybeWhen(
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      orElse: () =>
                          const Center(child: Text('No Assets Found')),
                      loaded: (nodes, filteredNodes, activeFilters) {
                        final nodesToShow =
                            filteredNodes.isEmpty ? nodes : filteredNodes;
                        final flattenedNodes = _buildFlattenedList(
                          nodesToShow,
                          0,
                          const [],
                        );
                        return ListView.builder(
                          itemCount: flattenedNodes.length,
                          itemBuilder: (context, index) {
                            return _buildNodeRow(flattenedNodes[index]);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FlatNode {
  final TreeNode node;
  final int depth;
  final List<TreeNode> scopingNodes;
  final bool isExpanded;

  _FlatNode(
    this.node,
    this.depth,
    this.scopingNodes,
    this.isExpanded,
  );
}

class _FilterChip extends StatelessWidget {
  final String label;
  final String iconPath;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  const _FilterChip({
    required this.label,
    required this.iconPath,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ImageAsset(
            iconPath,
            height: 16,
            color: isSelected ? Colors.white : null,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(color: isSelected ? Colors.white : null),
          ),
        ],
      ),
      selected: isSelected,
      onSelected: onSelected,
    );
  }
}
