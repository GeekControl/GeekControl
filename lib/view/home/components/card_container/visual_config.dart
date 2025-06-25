import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geekcontrol/core/utils/assets_enum.dart';

class VisualConfig {
  final BannerAssetsEnum image;
  final List<Color>? gradient;

  const VisualConfig({
    required this.image,
    this.gradient,
  });

  static List<VisualConfig> animeVisuals = [
    VisualConfig(
      image: BannerAssetsEnum.luffy,
    ),
    VisualConfig(
      image: BannerAssetsEnum.frieren,
      gradient: [
        Color.fromRGBO(42, 101, 239, 1),
        Color.fromARGB(255, 61, 8, 252),
      ],
    ),
    VisualConfig(
      image: BannerAssetsEnum.zenitsu,
      gradient: [
        Color.fromARGB(255, 138, 127, 6),
        Color.fromRGBO(99, 68, 1, 1),
      ],
    ),
  ];
}

class RandomVisualConfig {
  static final List<VisualConfig> visuals = [
    VisualConfig(
      image: BannerAssetsEnum.albedoWhite,
      gradient: [
        Color.fromARGB(255, 70, 59, 59),
        Color.fromARGB(255, 0, 0, 0),
      ],
    ),
    VisualConfig(
      image: BannerAssetsEnum.oshinoShinobuPink,
      gradient: [
        Color.fromRGBO(104, 61, 106, 1),
        Color.fromARGB(255, 170, 19, 100),
      ],
    ),
    VisualConfig(
      image: BannerAssetsEnum.oshinoShinobuPurple,
      gradient: [
        Color.fromRGBO(104, 61, 106, 1),
        Color.fromARGB(255, 170, 19, 100),
      ],
    ),
    VisualConfig(
      image: BannerAssetsEnum.shalltearWhite,
      gradient: [
        Color.fromARGB(255, 122, 86, 86),
        Color.fromARGB(255, 76, 20, 20),
      ],
    ),
    VisualConfig(
      image: BannerAssetsEnum.hitagi,
      gradient: [
        Color.fromRGBO(104, 61, 106, 1),
        Color.fromARGB(255, 170, 19, 100),
      ],
    ),
    VisualConfig(
      image: BannerAssetsEnum.soloLevelingPurple,
      gradient: [
        Color.fromRGBO(61, 12, 63, 1),
        Color.fromARGB(255, 91, 8, 54),
      ],
    ),
  ];

  static VisualConfig random() {
    final random = Random();
    return visuals[random.nextInt(visuals.length)];
  }
}
