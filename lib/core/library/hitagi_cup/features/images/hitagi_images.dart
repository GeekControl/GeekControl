import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geekcontrol/core/utils/assets_enum.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/skeletonizer/hitagi_shimmer_efect.dart';

class HitagiImages extends StatelessWidget {
  final String? image;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double shimmerWidth;
  final double shimmerHeight;

  const HitagiImages({
    super.key,
    required this.image,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.shimmerHeight = 150,
    this.shimmerWidth = 160,
  });

  @override
  Widget build(BuildContext context) {
    if (image == null || image!.isEmpty) {
      return Image.asset(AssetsEnum.defaultImage.path);
    }

    return CachedNetworkImage(
      imageUrl: image!,
      placeholder: (context, url) => HitagiShimmerEffect(
        height: shimmerHeight,
        width: shimmerWidth,
      ),
      errorWidget: (context, url, error) =>
          Image.asset(AssetsEnum.defaultImage.path),
      width: width,
      height: height,
      fit: fit,
    );
  }
}
