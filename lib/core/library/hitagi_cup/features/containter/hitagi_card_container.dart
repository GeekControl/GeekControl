import 'package:flutter/material.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/containter/hitagi_container.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/text/hitagi_text.dart';
import 'package:geekcontrol/view/services/anilist/entities/anilist_types_enum.dart';
import 'package:go_router/go_router.dart';

class HitagiCardContainer extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;
  final List<Color>? gradient;
  final String route;
  final AnilistTypes type;
  final String? backgroundImageAsset;

  const HitagiCardContainer({
    super.key,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.route,
    this.type = AnilistTypes.anime,
    this.gradient,
    this.backgroundImageAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradient ??
                  [
                    Color.fromARGB(255, 41, 2, 114),
                    Color.fromARGB(255, 8, 2, 66),
                  ],
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0xFFFF9800).withAlpha(77),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              if (backgroundImageAsset != null)
                Positioned.fill(
                  child: ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.10),
                          Colors.black,
                          Colors.black,
                        ],
                        stops: [0.0, 0.4, 0.7, 1.0],
                      ).createShader(bounds);
                    },
                    blendMode: BlendMode.dstIn,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(backgroundImageAsset!),
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                  ),
                ),
              Padding(
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
                          SizedBox(height: 12),
                          HitagiText(text: subtitle, color: Colors.white),
                          SizedBox(height: 8),
                          HitagiText(text: description, color: Colors.white),
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
                          onTap: () => GoRouter.of(context).push(route, extra: {
                            'season': title,
                            'type': type,
                          }),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Center(
                              child: HitagiText(
                                text: 'Ver todos',
                                color: gradient?.last ??
                                    Color.fromARGB(255, 41, 2, 114),
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
            ],
          ),
        ),
      ),
    );
  }
}
