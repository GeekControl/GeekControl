import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
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
          items: List.generate(5, (index) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8.0),
              ),
            );
          }),
        ),
      ),
    );
  }
}
