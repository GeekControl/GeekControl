import 'package:flutter/material.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/text/hitagi_text.dart';
import 'package:geekcontrol/view/services/anilist/entities/details_entity.dart';

class GenresComponent extends StatelessWidget {
  final DetailsEntity details;
  const GenresComponent({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: details.genres.map((genre) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: const Color.fromARGB(255, 46, 46, 46)),
            color: const Color.fromARGB(93, 124, 77, 255),
            borderRadius: BorderRadius.circular(6),
          ),
          child: HitagiText(
            text: genre,
            typography: HitagiTypography.button,
          ),
        );
      }).toList(),
    );
  }
}
