import 'package:flutter/material.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/text/hitagi_text.dart';
import 'package:geekcontrol/core/utils/global_variables.dart';
import 'package:geekcontrol/view/auth/controllers/auth_controller.dart';
import 'package:geekcontrol/view/auth/ui/login_page.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends StatefulWidget {
  static const route = '/register';
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final spacing = const SizedBox(height: 20);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const HitagiText(
                text: 'Criar Conta',
                typography: HitagiTypography.title,
              ),
              spacing,
              TextField(
                controller: ct.nameController,
                decoration: _inputDecoration('Nome'),
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
                    await ct.registerUser(
                        email: ct.emailController.text,
                        password: ct.passwordController.text,
                        name: ct.nameController.text,
                        context: context);
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
                    text: 'Criar Conta',
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
              TextButton(
                onPressed: () => GoRouter.of(context).go(LoginPage.route),
                child: const HitagiText(
                  text: 'Já tenho uma conta',
                  typography: HitagiTypography.button,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
