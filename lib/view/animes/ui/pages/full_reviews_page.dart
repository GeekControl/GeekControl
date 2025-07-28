import 'package:flutter/material.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/images/hitagi_images.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/text/hitagi_text.dart';
import 'package:geekcontrol/view/services/anilist/entities/reviews_entity.dart';

class FullReviewPage extends StatelessWidget {
  static const String route = '/full-review';
  final ReviewsEntity review;

  const FullReviewPage({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const HitagiText(
          text: 'Review Completa',
          typography: HitagiTypography.title,
          color: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: review.banner.isEmpty
                  ? BoxDecoration(
                      color: Colors.purple.shade50,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    )
                  : BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(review.banner),
                        fit: BoxFit.cover,
                      ),
                    ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.purple, width: 3),
                    ),
                    child: ClipOval(
                      child: review.avatar.isNotEmpty
                          ? HitagiImages(image: review.avatar)
                          : Container(
                              color: Colors.purple.shade100,
                              child: Icon(
                                Icons.person,
                                size: 40,
                                color: Colors.purple,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        HitagiText(
                          text:
                              '${(review.userRating / 10).toStringAsFixed(1)}/10',
                          typography: HitagiTypography.button,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (review.summary.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HitagiText(
                      text: 'Resumo',
                      typography: HitagiTypography.title,
                      color: Colors.purple,
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.purple.shade100,
                          width: 1,
                        ),
                      ),
                      child: HitagiText(
                        text: review.summary,
                        typography: HitagiTypography.body,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HitagiText(
                    text: 'Review Completa',
                    typography: HitagiTypography.title,
                    color: Colors.purple,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: HitagiText(
                      text: review.body.isNotEmpty
                          ? review.body
                          : 'Nenhuma review detalhada disponível.',
                      typography: HitagiTypography.body,
                      color: Colors.black87,
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
