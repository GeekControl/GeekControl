import 'package:flutter/material.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/text/hitagi_text.dart';

class DetailsComponent extends StatelessWidget {
  final IconData icon;
  final String label;
  final dynamic value;

  const DetailsComponent({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          HitagiText(
            text: '$label: ',
            typography: HitagiTypography.button,
          ),
          Expanded(
            child: HitagiText(
              text: value.toString(),
              typography: HitagiTypography.button,
            ),
          ),
        ],
      ),
    );
  }
}
