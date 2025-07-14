import 'package:flutter/material.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/text/hitagi_text.dart';

class HitagiNoContentPage extends StatelessWidget {
  final String? message;
  final VoidCallback? onAction;
  final String? actionLabel;

  const HitagiNoContentPage({
    super.key,
    this.message,
    this.onAction,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.search_off_outlined,
                  size: 64,
                  color: Colors.blue[400],
                ),
              ),
              const SizedBox(height: 32),
              HitagiText(
                text: 'Nada por aqui',
                color: Colors.grey[800],
                typography: HitagiTypography.giga,
              ),
              const SizedBox(height: 12),
              HitagiText(
                text: message ?? 'Não encontramos nenhum conteúdo.',
                textAlign: TextAlign.center,
                color: Colors.grey[600],
                typography: HitagiTypography.body,
              ),
              const SizedBox(height: 48),
              if (onAction != null) ...[
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            colors: [Colors.blue[400]!, Colors.blue[600]!],
                          ),
                        ),
                        child: ElevatedButton(
                          onPressed: onAction,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.add, color: Colors.white),
                              const SizedBox(width: 8),
                              HitagiText(
                                text: actionLabel ?? 'Adicionar',
                                color: Colors.white,
                                typography: HitagiTypography.button,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
