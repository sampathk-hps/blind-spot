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

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});
  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      body: Stack(
        children: [
          // Decorative background blobs
          Positioned(
            top: -50,
            right: -50,
            child: IgnorePointer(
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.gradientStart
                      .withOpacity(context.isDark ? 0.15 : 0.08),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: IgnorePointer(
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.gradientEnd
                      .withOpacity(context.isDark ? 0.15 : 0.08),
                ),
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSizes.screenPadding),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSizes.xxl),

                    // App logo + name
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [
                              AppColors.gradientStart,
                              AppColors.gradientEnd,
                            ]),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.shield_rounded,
                              color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          AppStrings.appName,
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: context.primaryTextColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.xxxl),

                    // Heading
                    Text(
                      AppStrings.welcomeBack,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: context.primaryTextColor,
                      ),
                    ),
                    const SizedBox(height: AppSizes.sm),
                    Text(
                      AppStrings.signInToAccount,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: context.secondaryTextColor,
                      ),
                    ),
                    const SizedBox(height: AppSizes.xl),

                    // Email field
                    BSTextField(
                      label: AppStrings.emailLabel,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) => v == null || v.isEmpty
                          ? AppStrings.required
                          : null,
                    ),
                    const SizedBox(height: AppSizes.md),

                    // Password field
                    BSTextField(
                      label: AppStrings.passwordLabel,
                      controller: _passwordController,
                      obscureText: true,
                      validator: (v) => v == null || v.length < 6
                          ? AppStrings.passwordTooShort
                          : null,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(AppStrings.forgotPassword),
                      ),
                    ),
                    const SizedBox(height: AppSizes.lg),

                    // Sign In button
                    BSButton.primary(
                      label: AppStrings.signIn,
                      isLoading: isLoading,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            await ref
                                .read(authNotifierProvider.notifier)
                                .signInWithEmail(
                                  _emailController.text.trim(),
                                  _passwordController.text,
                                );
                            if (mounted) context.go('/dashboard');
                          } catch (e) {
                            if (mounted)
                              context.showSnackBar(e.toString(),
                                  isError: true);
                          }
                        }
                      },
                    ),
                    const SizedBox(height: AppSizes.xl),

                    // Divider
                    Row(
                      children: [
                        Expanded(child: Divider(color: context.borderColor)),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            AppStrings.orDivider,
                            style: GoogleFonts.inter(
                                color: context.secondaryTextColor),
                          ),
                        ),
                        Expanded(child: Divider(color: context.borderColor)),
                      ],
                    ),
                    const SizedBox(height: AppSizes.xl),

                    // Google Sign-In
                    BSButton.secondary(
                      label: AppStrings.continueWithGoogle,
                      icon: Icons.g_mobiledata_rounded,
                      onPressed: () =>
                          context.showSnackBar(AppStrings.googleSignInComingSoon),
                    ),
                    const SizedBox(height: AppSizes.xxl),

                    // Sign Up link
                    Center(
                      child: TextButton(
                        onPressed: () => context.go('/auth/sign-up'),
                        child: RichText(
                          text: TextSpan(
                            text: AppStrings.noAccountPrompt,
                            style: GoogleFonts.inter(
                                color: context.secondaryTextColor),
                            children: [
                              TextSpan(
                                text: AppStrings.signUp,
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
