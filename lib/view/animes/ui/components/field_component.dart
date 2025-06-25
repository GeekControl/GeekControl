import 'package:flutter/material.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/text/hitagi_text.dart';

class FieldComponent extends StatelessWidget {
  final String field;
  final IconData? icon;
  const FieldComponent({super.key, required this.field, this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon ?? Icons.person_rounded, size: 16, color: Colors.white),
        const SizedBox(width: 8),
        HitagiText(
          text: field,
          color: Colors.white,
        ),
      ],
    );
  }
}
