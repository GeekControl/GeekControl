import 'package:flutter/material.dart';

class CreateCategoryTextField extends StatefulWidget {
  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController controller;

  const CreateCategoryTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    required this.controller,
  });

  @override
  State<CreateCategoryTextField> createState() =>
      _CreateCategoryTextFieldState();
}

class _CreateCategoryTextFieldState extends State<CreateCategoryTextField> {
  late String currentColor;

  @override
  void initState() {
    super.initState();
    currentColor = widget.controller.text;
    widget.controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {
      currentColor = widget.controller.text;
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  Color _parseColor(String colorHex) {
    try {
      return Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
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
          widget.label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3436),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: TextField(
            controller: widget.controller,
            style: const TextStyle(color: Color(0xFF2D3436), fontSize: 16),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: const TextStyle(color: Colors.grey),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              prefixIcon: Icon(
                widget.icon,
                color: _parseColor(currentColor),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
