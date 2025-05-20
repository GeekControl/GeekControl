import 'package:flutter/material.dart';
import 'package:geekcontrol/core/utils/assets_enum.dart';

class VisualConfig {
  final String image;
  final List<Color>? gradient;

  const VisualConfig({
    required this.image,
    this.gradient,
  });

  static List<VisualConfig> animeVisuals = [
    VisualConfig(
      image: AssetsEnum.luffy.path,
    ),
    VisualConfig(
      image: AssetsEnum.frieren.path,
      gradient: [
        Color.fromRGBO(42, 101, 239, 1),
        Color.fromARGB(255, 61, 8, 252),
      ],
    ),
    VisualConfig(
      image: AssetsEnum.zenitsu.path,
      gradient: [
        Color.fromARGB(255, 138, 127, 6),
        Color.fromRGBO(99, 68, 1, 1),
      ],
    ),
  ];
}
