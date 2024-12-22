import '../domain.dart';

abstract class BuildTreeNodes {
  List<TreeNode> call({
    required List<Location> locations,
    required List<Asset> assets,
  });
}

class BuildTreeNodesImpl implements BuildTreeNodes {
  @override
  List<TreeNode> call({
    required List<Location> locations,
    required List<Asset> assets,
  }) {
    final locationMap = {for (var location in locations) location.id: location};
    final assetMap = {for (var asset in assets) asset.id: asset};

    final rootLocations = locations.where((loc) => loc.parentId == null);
    final locationNodes = rootLocations.map((location) {
      return TreeNode(
        id: location.id,
        name: location.name,
        type: NodeType.location,
        children: _buildLocationChildren(location.id, locationMap, assetMap),
      );
    }).toList();

    final unlinkedItems = assets.where(
      (asset) => asset.locationId == null && asset.parentId == null,
    );
    final unlinkedNodes =
        unlinkedItems.map((asset) => _buildAssetNode(asset, assetMap)).toList();

    return [...locationNodes, ...unlinkedNodes];
  }

  List<TreeNode> _buildLocationChildren(
    String locationId,
    Map<String, Location> locationMap,
    Map<String, Asset> assetMap,
  ) {
    // Get sub-locations
    final subLocations =
        locationMap.values.where((loc) => loc.parentId == locationId);
    final subLocationNodes = subLocations.map((location) {
      return TreeNode(
        id: location.id,
        name: location.name,
        type: NodeType.location,
        children: _buildLocationChildren(location.id, locationMap, assetMap),
      );
    }).toList();

    // Get location assets
    final locationAssets =
        assetMap.values.where((asset) => asset.locationId == locationId);
    final locationAssetNodes = locationAssets
        .map((asset) => _buildAssetNode(asset, assetMap))
        .toList();

    return [...subLocationNodes, ...locationAssetNodes];
  }

  TreeNode _buildAssetNode(Asset asset, Map<String, Asset> assetMap) {
    if (asset.isComponent) {
      return TreeNode(
        id: asset.id,
        name: asset.name,
        type: NodeType.component,
        componentInfo: ComponentInfo(
          sensorId: asset.sensorId!,
          sensorType: _mapSensorType(asset.sensorType!),
          status: asset.status,
          gatewayId: asset.gatewayId!,
        ),
        children: const [],
      );
    }

    return TreeNode(
      id: asset.id,
      name: asset.name,
      type: NodeType.asset,
      children: _buildAssetChildren(asset.id, assetMap),
    );
  }

  List<TreeNode> _buildAssetChildren(
      String assetId, Map<String, Asset> assetMap) {
    final children =
        assetMap.values.where((asset) => asset.parentId == assetId);
    return children.map((asset) => _buildAssetNode(asset, assetMap)).toList();
  }

  SensorType _mapSensorType(String type) {
    return switch (type) {
      'vibration' => SensorType.vibration,
      'energy' => SensorType.energy,
      _ => throw Exception('Invalid sensor type: $type'),
    };
  }
}