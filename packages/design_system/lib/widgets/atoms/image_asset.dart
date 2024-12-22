import 'package:flutter/material.dart';

class ImageAsset extends StatelessWidget {
  final String assetName;
  final double? height;
  final double? width;
  final Color? color;

  const ImageAsset(
    this.assetName, {
    super.key,
    this.height,
    this.width,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/$assetName',
      height: height,
      width: width,
      package: 'design_system',
      color: color,
    );
  }
}
