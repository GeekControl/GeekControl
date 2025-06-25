import 'package:flutter/material.dart';
import 'package:geekcontrol/view/library/ui/predefined_colors.dart';

class CreateCategoryColors extends StatefulWidget {
  final TextEditingController colorCtrl;

  const CreateCategoryColors({
    super.key,
    required this.colorCtrl,
  });

  @override
  State<CreateCategoryColors> createState() => _CreateCategoryColorsState();
}

class _CreateCategoryColorsState extends State<CreateCategoryColors> {
  Color parseColor(String hex) {
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (_) {
      return const Color(0xFF6C5CE7);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cores Sugeridas',
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: PredefinedColors().colors.map((hex) {
            final isSelected =
                widget.colorCtrl.text.trim().toUpperCase() == hex.toUpperCase();
            return GestureDetector(
              onTap: () {
                widget.colorCtrl.text = hex;
                setState(() {});
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: parseColor(hex),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF2D3436)
                        : Colors.grey.shade300,
                    width: isSelected ? 3 : 2,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                              color: parseColor(hex).withValues(alpha: 0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 4))
                        ]
                      : null,
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white, size: 20)
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
