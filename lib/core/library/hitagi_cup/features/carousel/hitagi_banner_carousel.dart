import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/images/hitagi_images.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/text/hitagi_text.dart';
import 'package:url_launcher/url_launcher.dart';

class HitagiBanner extends StatefulWidget {
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
  State<HitagiBanner> createState() => _HitagiBannerState();
}

class _HitagiBannerState extends State<HitagiBanner> {
  int currentIndex = 0;
  late CarouselSliderController carouselController;

  @override
  void initState() {
    super.initState();
    carouselController = CarouselSliderController();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.title != null ? 280 : 200,
      child: Stack(
        children: [
          CarouselSlider.builder(
            carouselController: carouselController,
            options: CarouselOptions(
              height: widget.title != null ? 280 : 200,
              aspectRatio: 16 / 9,
              enlargeCenterPage: false,
              autoPlay: widget.images.length > 1,
              autoPlayInterval: const Duration(seconds: 4),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              enableInfiniteScroll: widget.images.length > 1,
              viewportFraction: 1.0,
              onPageChanged: (index, reason) {
                setState(() {
                  currentIndex = index;
                });
              },
            ),
            itemCount: widget.images.length,
            itemBuilder: (context, index, realIndex) {
              return GestureDetector(
                onTap: () => widget.onTap != null 
                    ? widget.onTap!(index) 
                    : launchUrl(Uri.parse(widget.images[index])),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      HitagiImages(
                        image: widget.images[index],
                        width: double.infinity,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.3),
                              Colors.black.withValues(alpha: 0.7),
                            ],
                            stops: const [0.0, 0.6, 1.0],
                          ),
                        ),
                      ),
                      if (widget.title != null)
                        Positioned(
                          bottom: 24,
                          left: 24,
                          right: 24,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              HitagiText(
                                text: widget.title!,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                color: Colors.white,
                                typography: HitagiTypography.title,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
          if (widget.images.length > 1) ...[
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.images.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () => carouselController.animateToPage(entry.key),
                    child: Container(
                      width: currentIndex == entry.key ? 24 : 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: currentIndex == entry.key
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.4),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: HitagiText(
                  text: '${currentIndex + 1}/${widget.images.length}',
                  color: Colors.white,
                  typography: HitagiTypography.small,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}