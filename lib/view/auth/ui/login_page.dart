import 'package:flutter/material.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/text/hitagi_text.dart';
import 'package:geekcontrol/core/utils/global_variables.dart';
import 'package:geekcontrol/view/auth/controllers/auth_controller.dart';
import 'package:geekcontrol/view/auth/ui/register_page.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  static const route = '/login';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final ct = di<AuthController>();

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: Colors.grey[100],
    );
  }

  @override
  Widget build(BuildContext context) {
    final spacing = const SizedBox(height: 20);
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const HitagiText(
                text: 'Entrar',
                typography: HitagiTypography.title,
              ),
              spacing,
              TextField(
                controller: ct.emailController,
                decoration: _inputDecoration('E-mail'),
                keyboardType: TextInputType.emailAddress,
              ),
              spacing,
              TextField(
                controller: ct.passwordController,
                decoration: _inputDecoration('Senha'),
                obscureText: true,
              ),
              spacing,
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await ct.loginUser(
                      email: ct.emailController.text,
                      password: ct.passwordController.text,
                      context: context,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const HitagiText(
                    text: 'Entrar',
                    typography: HitagiTypography.button,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const HitagiText(text: 'ou', color: Colors.black87),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: null,
                  icon: Image.network(
                    'https://upload.wikimedia.org/wikipedia/commons/0/09/IOS_Google_icon.png',
                    height: 20,
                    width: 20,
                  ),
                  label: const HitagiText(
                    text: 'Entrar com Google',
                    typography: HitagiTypography.button,
                    color: Colors.black,
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: const BorderSide(color: Colors.black12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () =>
                        GoRouter.of(context).go(RegisterPage.route),
                    child: const HitagiText(
                      text: 'Não tenho uma conta',
                      typography: HitagiTypography.button,
                    ),
                  ),
                  Container(
                    height: 20,
                    width: 1,
                    color: Colors.black26,
                    margin: EdgeInsets.symmetric(horizontal: width * 0.01),
                  ),
                  TextButton(
                    onPressed: () async {
                      await ct.setAnonymousMode();
                      if (context.mounted) {
                        GoRouter.of(context).go('/');
                      }
                    },
                    child: const HitagiText(
                      text: 'Continuar sem login',
                      typography: HitagiTypography.button,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
