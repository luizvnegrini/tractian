import 'dart:async';

import 'package:design_system/design_system.dart';
import 'package:external_dependencies/external_dependencies.dart';
import 'package:flutter/material.dart';

import '../../domain/domain.dart';
import '../presentation.dart';
import 'assets_page_state.dart';
import 'widgets/widgets.dart';

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

  void _toggleNode(TreeNode node) {
    setState(() {
      _expandedNodes[node.id] = !(_expandedNodes[node.id] ?? false);
    });
  }

  List<FlatNode> _buildFlattenedList(List<TreeNode> nodes,
      [int depth = 0, List<TreeNode> scopingNodes = const []]) {
    List<FlatNode> flattened = [];

    for (var i = 0; i < nodes.length; i++) {
      final node = nodes[i];
      final hasChildren = node.children.isNotEmpty;
      final isExpanded = _expandedNodes[node.id] ?? false;

      flattened.add(FlatNode(
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

  @override
  Widget build(BuildContext context) {
    final isEnergySensorSelected =
        _selectedFilters.contains(FilterType.energySensor);
    final isCriticalSelected = _selectedFilters.contains(FilterType.critical);

    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Assets'),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Container(
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
                        CustomFilterChip(
                          label: 'Sensor de Energia',
                          iconPath: 'filter_bolt.png',
                          isSelected: isEnergySensorSelected,
                          onSelected: (_) =>
                              _onFilterSelected(FilterType.energySensor),
                        ),
                        const SizedBox(width: 8),
                        CustomFilterChip(
                          label: 'Crítico',
                          iconPath: 'filter_exclamation.png',
                          isSelected: isCriticalSelected,
                          onSelected: (_) =>
                              _onFilterSelected(FilterType.critical),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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
                          itemBuilder: (_, index) {
                            final node = flattenedNodes[index].node;

                            return NodeRow(
                              flatNode: flattenedNodes[index],
                              isExpanded: _expandedNodes[node.id] ?? false,
                              hasChildren: node.children.isNotEmpty,
                              onTap: _toggleNode,
                              depth: flattenedNodes[index].depth,
                            );
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
