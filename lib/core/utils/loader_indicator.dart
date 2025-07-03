import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class Loader extends LoadingIndicator {
  const Loader({
    super.key,
    required super.indicatorType,
    super.colors,
    super.backgroundColor,
    super.pathBackgroundColor,
    super.pause,
    super.strokeWidth,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      width: 80,
      child: LoadingIndicator(
        indicatorType: indicatorType,
        colors: colors,
        backgroundColor: backgroundColor,
        pathBackgroundColor: pathBackgroundColor,
        pause: pause,
        strokeWidth: strokeWidth,
      ),
    );
  }

  factory Loader.pacman() {
    return const Loader(
      indicatorType: Indicator.pacman,
      colors: [Colors.orange, Colors.yellow, Colors.black],
    );
  }

  factory Loader.ballPulse() {
    return const Loader(
      indicatorType: Indicator.ballPulse,
      colors: [Colors.purple],
    );
  }
}
