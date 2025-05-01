import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geekcontrol/home/components/shimmer_efect.dart';

class HitagiImages extends StatelessWidget {
  final String? image;
  final double? width;
  final double? height;
  final BoxFit fit;

  const HitagiImages({
    super.key,
    required this.image,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    if (image == null || image!.isEmpty) {
      return Image.asset('assets/default.png');
    }

    return CachedNetworkImage(
      imageUrl: image!,
      placeholder: (context, url) => const ShimmerEffect(
        height: 150,
        width: 160,
      ),
      errorWidget: (context, url, error) => Image.asset('assets/default.png'),
      width: width,
      height: height,
      fit: fit,
    );
  }
}
