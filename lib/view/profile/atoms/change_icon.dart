import 'package:flutter/material.dart';
import '../../../core/library/hitagi_cup/features/text/hitagi_text.dart';

class ChangeIconWidget extends StatelessWidget {
  const ChangeIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              title: const HitagiText(text: 'Mudar ícone'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Mudar'),
                  ),
                  const SizedBox(height: 20),
                  const Icon(
                    Icons.image,
                    size: 60,
                  ),
                ],
              ),
            );
          },
        );
      },
      child: const Text('Abrir popup de mudança de ícone'),
    );
  }
}
