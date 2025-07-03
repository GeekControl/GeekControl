import 'package:flutter/material.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/text/hitagi_text.dart';
import 'package:geekcontrol/view/auth/ui/login_page.dart';
import 'package:go_router/go_router.dart';

class MoveToLogin extends StatelessWidget {
  final String title;
  const MoveToLogin({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock_outline,
                size: 80,
                color: Colors.red[400],
              ),
              const SizedBox(height: 32),
              HitagiText(
                text: 'Acesso Restrito',
                typography: HitagiTypography.title,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              HitagiText(
                text: 'Você deve estar logado para acessar $title.',
                typography: HitagiTypography.button,
                textAlign: TextAlign.center,
                color: Colors.grey[600],
              ),
              const SizedBox(height: 32),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color.fromARGB(255, 176, 117, 212),
                      const Color.fromARGB(255, 160, 120, 207)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () => GoRouter.of(context).push(LoginPage.route),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const HitagiText(
                    text: 'Fazer Login',
                    typography: HitagiTypography.button,
                    color: Colors.white,
                    isBold: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
