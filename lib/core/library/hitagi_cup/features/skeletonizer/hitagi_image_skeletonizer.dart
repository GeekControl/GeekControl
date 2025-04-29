import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HitagiImageSkeleton extends StatelessWidget {
  final double? width;
  final double? height;

  const HitagiImageSkeleton({
    super.key,
    this.width = 200,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer.zone(
      enableSwitchAnimation: true,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: width,
          height: height,
        ),
      ),
    );
  }
}
