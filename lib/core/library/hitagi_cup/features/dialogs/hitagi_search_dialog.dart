import 'package:flutter/material.dart';

class HitagiSearchDialog extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final IconData prefixIcon;
  final IconData suffixIcon;
  final Color? backgroundColor;
  final Color? fillColor;
  final Color? iconColor;
  final Color? suffixBackgroundColor;
  final double borderRadius;
  final EdgeInsetsGeometry contentPadding;

  const HitagiSearchDialog({
    super.key,
    required this.controller,
    required this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.prefixIcon = Icons.search,
    this.suffixIcon = Icons.arrow_forward_rounded,
    this.backgroundColor,
    this.fillColor,
    this.iconColor,
    this.suffixBackgroundColor,
    this.borderRadius = 16,
    this.contentPadding =
        const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
  });

  @override
  Widget build(BuildContext context) {
    final effectiveFillColor = fillColor ?? Colors.grey.shade50;
    final effectiveIconColor = iconColor ?? Colors.grey.shade600;
    final effectiveSuffixBackground =
        suffixBackgroundColor ?? Colors.blue.shade600;
    final effectiveBackground = backgroundColor ?? Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: effectiveBackground,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey.shade800,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 16,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              prefixIcon,
              color: effectiveIconColor,
              size: 20,
            ),
          ),
          suffixIcon: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.all(8),
            child: Material(
              color: effectiveSuffixBackground,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  if (onSubmitted != null) {
                    onSubmitted!(controller.text);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Icon(
                    suffixIcon,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: Colors.blue.shade400,
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: effectiveFillColor,
          contentPadding: contentPadding,
        ),
      ),
    );
  }
}
