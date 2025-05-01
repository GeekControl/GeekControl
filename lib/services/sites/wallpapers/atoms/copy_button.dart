import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CoppyButton extends StatelessWidget {
  final String image;
  const CoppyButton({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.copy, size: 20),
      color: Colors.white,
      onPressed: () {
        Clipboard.setData(
          ClipboardData(text: image),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Link copiado')),
        );
      },
    );
  }
}
