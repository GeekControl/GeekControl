import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/skeletonizer/hitagi_shimmer_efect.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CarouselSkeletonizer extends StatelessWidget {
  const CarouselSkeletonizer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Skeletonizer(
        enabled: false,
        child: CarouselSlider(
          options: CarouselOptions(
            height: 180,
            enlargeCenterPage: false,
            enlargeFactor: 0.3,
            autoPlay: false,
            autoPlayCurve: Curves.easeInOutBack,
            viewportFraction: 0.4,
          ),
          items: List<Widget>.generate(3, (index) {
            return HitagiShimmerEffect(height: 150, width: 160);
          }),
        ),
      ),
    );
  }
}
