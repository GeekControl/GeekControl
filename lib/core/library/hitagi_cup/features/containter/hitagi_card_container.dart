import 'package:flutter/material.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/containter/hitagi_container.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/text/hitagi_text.dart';
import 'package:go_router/go_router.dart';

class HitagiCardContainer extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;
  final List<Color>? gradient;
  final String route;

  const HitagiCardContainer({
    super.key,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.route,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradient ??
                [
                  Color(0xFFFF9800),
                  Color(0xFFFF5722),
                ],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF9800).withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: HitagiText(
                        text: title,
                        color: Colors.white,
                        typography: HitagiTypography.title,
                      ),
                    ),
                    const SizedBox(height: 12),
                    HitagiText(
                      text: subtitle,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 8),
                    HitagiText(
                      text: description,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              HitagiContainer(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => GoRouter.of(context).push(route, extra: title),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Center(
                        child: HitagiText(
                          text: 'Ver todos',
                          color: Color(0xFFFF5722),
                          typography: HitagiTypography.button,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
