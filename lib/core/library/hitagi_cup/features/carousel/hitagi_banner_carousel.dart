import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/images/hitagi_images.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/text/hitagi_text.dart';
import 'package:url_launcher/url_launcher.dart';

class HitagiBanner extends StatelessWidget {
  final List<String> images;
  final String? title;
  final void Function(int index)? onTap;

  const HitagiBanner({
    super.key,
    required this.images,
    this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      options: CarouselOptions(
        height: title != null ? 200 : 150,
        aspectRatio: 16 / 9,
        enlargeCenterPage: true,
        autoPlay: images.length > 1,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(seconds: 1),
        enableInfiniteScroll: images.length > 1,
        viewportFraction: images.length > 1 ? 0.8 : 1,
      ),
      itemCount: images.length,
      itemBuilder: (context, index, realIndex) {
        return GestureDetector(
          onTap: () =>  onTap != null ? onTap!(index) : launchUrl(Uri.parse(images[index])),
          child: title != null
              ? Stack(
                  children: [
                    HitagiImages(
                      image: images[index],
                      width: double.infinity,
                    ),
                    Positioned(
                      bottom: 10,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: HitagiText(
                          text: title!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          color: Colors.white,
                          typography: HitagiTypography.button,
                        ),
                      ),
                    ),
                  ],
                )
              : HitagiImages(
                  image: images[index],
                  width: double.infinity,
                ),
        );
      },
    );
  }
}
