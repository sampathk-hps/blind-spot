import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:blindspot/core/constants/app_colors.dart';
import 'package:blindspot/core/constants/app_sizes.dart';
import 'package:blindspot/core/constants/app_strings.dart';
import 'package:blindspot/shared/extensions/build_context_ext.dart';
import 'package:blindspot/shared/widgets/bs_button.dart';
import 'package:blindspot/shared/widgets/bs_text_field.dart';
import 'package:blindspot/features/auth/presentation/providers/auth_provider.dart';
import 'package:google_fonts/google_fonts.dart';

/// Sign-up screen. All UI strings sourced from [AppStrings].
class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});
  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.screenPadding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSizes.xl),
                Text(
                  AppStrings.createYourAccount,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: context.primaryTextColor,
                  ),
                ),
                const SizedBox(height: AppSizes.sm),
                Text(
                  'Join ${AppStrings.appName} today',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: context.secondaryTextColor,
                  ),
                ),
                const SizedBox(height: AppSizes.xl),

                // Full name
                BSTextField(
                  label: AppStrings.fullNameLabel,
                  controller: _nameController,
                  validator: (v) =>
                      v == null || v.isEmpty ? AppStrings.required : null,
                ),
                const SizedBox(height: AppSizes.md),

                // Email
                BSTextField(
                  label: AppStrings.emailLabel,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) =>
                      v == null || v.isEmpty ? AppStrings.required : null,
                ),
                const SizedBox(height: AppSizes.md),

                // Password
                BSTextField(
                  label: AppStrings.passwordLabel,
                  controller: _passwordController,
                  obscureText: true,
                  validator: (v) =>
                      v == null || v.length < 8 ? 'Min 8 chars' : null,
                ),
                const SizedBox(height: AppSizes.md),

                // Confirm password
                BSTextField(
                  label: AppStrings.confirmPasswordLabel,
                  controller: _confirmPasswordController,
                  obscureText: true,
                  validator: (v) => v != _passwordController.text
                      ? 'Passwords do not match'
                      : null,
                ),
                const SizedBox(height: AppSizes.xl),

                // Create account button
                BSButton.primary(
                  label: AppStrings.createYourAccount,
                  isLoading: isLoading,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        await ref
                            .read(authNotifierProvider.notifier)
                            .signUpWithEmail(
                              _emailController.text.trim(),
                              _passwordController.text,
                              _nameController.text.trim(),
                            );
                        if (mounted) context.go('/dashboard');
                      } catch (e) {
                        if (mounted)
                          context.showSnackBar(e.toString(), isError: true);
                      }
                    }
                  },
                ),
                const SizedBox(height: AppSizes.xl),

                // Already have account
                Center(
                  child: TextButton(
                    onPressed: () => context.go('/auth/sign-in'),
                    child: RichText(
                      text: TextSpan(
                        text: AppStrings.alreadyHaveAccount,
                        style: GoogleFonts.inter(
                            color: context.secondaryTextColor),
                        children: [
                          TextSpan(
                            text: AppStrings.signIn,
                            style: GoogleFonts.inter(
                              color: AppColors.brandAccent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.lg),

                // Legal note
                Center(
                  child: Text(
                    'By signing up, you agree to our Terms and Privacy Policy.',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: context.textTertiary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
