import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:geekcontrol/view/animes/articles/controller/articles_controller.dart';
import 'package:geekcontrol/view/animes/articles/entities/articles_entity.dart';
import 'package:geekcontrol/view/animes/articles/pages/complete_article_page.dart';
import 'package:geekcontrol/view/home/components/carousel_skeletonizer.dart';
import 'package:logger/logger.dart';

class BannerCarousel extends StatelessWidget {
  const BannerCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ArticlesEntity>>(
      future: ArticlesController().bannerNews(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<ArticlesEntity> articles = snapshot.data!;
          return CarouselSlider(
            options: CarouselOptions(
              height: 150,
              enlargeCenterPage: true,
              aspectRatio: 16 / 9,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(seconds: 1),
              enableInfiniteScroll: true,
              viewportFraction: 0.8,
            ),
            items: articles.map((entry) {
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return FadeTransition(
                        opacity: animation,
                        child: CompleteArticlePage(
                          news: entry,
                          current: entry.site,
                        ),
                      );
                    },
                  ),
                ),
                child: Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                          image: NetworkImage(entry.imageUrl!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 7,
                      left: 2,
                      right: 2,
                      child: Container(
                        width: MediaQuery.of(context).size.width - 20,
                        padding: const EdgeInsets.all(4.0),
                        color: Colors.black.withValues(alpha: 0.7),
                        child: Text(
                          entry.title,
                          maxLines: 3,
                          overflow: TextOverflow.fade,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        } else {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CarouselSkeletonizer();
          } else {
            Logger().e(snapshot.error);
            return const CarouselSkeletonizer();
          }
        }
      },
    );
  }
}
