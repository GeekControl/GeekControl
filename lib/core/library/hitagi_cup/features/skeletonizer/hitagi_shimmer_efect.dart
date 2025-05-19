import 'package:flutter/material.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/containter/hitagi_container.dart';
import 'package:shimmer/shimmer.dart';

class HitagiShimmerEffect extends StatelessWidget {
  final double height; 
  final double width;
  const HitagiShimmerEffect({super.key,required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[900]!,
      highlightColor: Theme.of(context).colorScheme.primary,
      child: HitagiContainer(
        color: Colors.grey[400],
        height: height,
        width: width,
      ),
    );
  }
}
