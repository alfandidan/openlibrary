import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../core/utils/validators.dart';
import '../providers/auth_provider.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final success = await ref
        .read(authProvider.notifier)
        .sendPasswordResetEmail(_emailController.text.trim());

    setState(() {
      _isLoading = false;
      _emailSent = true;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Link reset password telah dikirim ke email Anda'
                : 'Jika email terdaftar, link reset akan dikirim',
          ),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Icon
                Icon(
                  _emailSent ? Icons.mark_email_read : Icons.lock_reset,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 24),

                // Title
                Text(
                  _emailSent ? 'Email Terkirim' : 'Lupa Password',
                  style: Theme.of(context).textTheme.headlineLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  _emailSent
                      ? 'Silakan cek email Anda untuk link reset password'
                      : 'Masukkan email untuk menerima link reset password',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                if (!_emailSent) ...[
                  // Email Field
                  CustomTextField(
                    controller: _emailController,
                    label: 'Email',
                    hint: 'Masukkan email terdaftar',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                    validator: Validators.email,
                    enabled: !_isLoading,
                  ),
                  const SizedBox(height: 24),

                  // Submit Button
                  CustomButton(
                    text: 'Kirim Link Reset',
                    onPressed: _isLoading ? null : _handleSubmit,
                    isLoading: _isLoading,
                  ),
                ] else ...[
                  // Back to Login Button
                  CustomButton(
                    text: 'Kembali ke Login',
                    onPressed: () => context.go('/login'),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      setState(() => _emailSent = false);
                    },
                    child: const Text('Kirim ulang email'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
