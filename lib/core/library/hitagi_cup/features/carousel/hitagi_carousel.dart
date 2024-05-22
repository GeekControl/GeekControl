import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HitagiCarousel extends StatelessWidget {
  final List<String> images;
  final String title;

  const HitagiCarousel({
    super.key,
    required this.images,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      options: CarouselOptions(
        height: 200,
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
          onTap: () => launchUrl(Uri.parse(images[index])),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  images[index],
                  height: 235,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Placeholder(
                      fallbackWidth: 200,
                      fallbackHeight: 200,
                      color: Colors.grey,
                    );
                  },
                ),
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
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
