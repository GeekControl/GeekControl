import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/dialogs/hitagi_toast.dart';

class CopyButton extends StatelessWidget {
  final String image;
  const CopyButton({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.copy, size: 20),
      color: Colors.white,
      onPressed: () {
        try {
          Clipboard.setData(
            ClipboardData(text: image),
          );
          HitagiToast.show(
            context,
            message: 'Wallpaper copiado para a área de transferência!',
            type: ToastType.success,
          );
        } catch (e) {
          HitagiToast.show(
            context,
            message: 'Erro ao copiar o wallpaper: $e',
            type: ToastType.error,
          );
        }
      },
    );
  }
}
