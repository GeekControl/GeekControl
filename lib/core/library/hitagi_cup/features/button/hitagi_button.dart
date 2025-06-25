import 'package:flutter/material.dart';
import '../text/hitagi_text.dart';

enum IconPosition {
  left,
  right,
}

class HitagiButton extends TextButton {
  final String label;
  final Color? colorButton;
  final Color? colorText;
  final EdgeInsetsGeometry padding;
  final double? elevation;
  final HitagiTypography typography;
  final IconPosition iconPosition;

  HitagiButton({
    super.key,
    required this.label,
    required super.onPressed,
    this.colorButton,
    this.colorText,
    this.padding = const EdgeInsets.symmetric(horizontal: 32),
    this.elevation,
    this.typography = HitagiTypography.button,
    this.iconPosition = IconPosition.left,
  }) : super(
          child: HitagiText(
            text: label,
            typography: typography,
            color: colorText ?? Colors.black,
          ),
          style: TextButton.styleFrom(
            elevation: elevation,
            backgroundColor:
                colorButton ?? const Color.fromARGB(132, 128, 9, 86),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: padding,
          ),
        );

  HitagiButton.icon({
    super.key,
    required this.label,
    required super.onPressed,
    this.colorButton,
    this.colorText,
    this.padding = const EdgeInsets.symmetric(horizontal: 32),
    this.elevation,
    this.typography = HitagiTypography.button,
    required IconData icon,
    this.iconPosition = IconPosition.left,
  }) : super(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (iconPosition == IconPosition.left) ...[
                Icon(
                  icon,
                  size: 18,
                  color: Colors.black,
                ),
                const SizedBox(width: 6),
              ],
              HitagiText(
                text: label,
                typography: typography,
                color: colorText ?? const Color.fromARGB(255, 0, 0, 0),
              ),
              if (iconPosition == IconPosition.right) ...[
                const SizedBox(width: 6),
                Icon(
                  icon,
                  size: 18,
                  color: Colors.black,
                ),
              ],
            ],
          ),
          style: TextButton.styleFrom(
            elevation: elevation,
            backgroundColor: colorButton ?? Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: padding,
          ),
        );

  HitagiButton.text({
    super.key,
    required this.label,
    required super.onPressed,
    this.colorButton,
    this.colorText,
    this.padding = const EdgeInsets.symmetric(horizontal: 32),
    this.elevation,
    this.iconPosition = IconPosition.left,
    this.typography = HitagiTypography.button,
  }) : super(
          child: HitagiText(
            text: label,
            typography: typography,
            color: colorText ?? Colors.white,
          ),
        );
}
