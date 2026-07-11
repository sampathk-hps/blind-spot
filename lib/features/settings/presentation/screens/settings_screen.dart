import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:blindspot/core/constants/app_sizes.dart';
import 'package:blindspot/core/constants/app_colors.dart';
import 'package:blindspot/core/constants/app_strings.dart';
import 'package:blindspot/core/di/providers.dart';
import 'package:blindspot/shared/extensions/build_context_ext.dart';
import 'package:blindspot/shared/widgets/bs_app_bar.dart';
import 'package:blindspot/features/auth/presentation/providers/auth_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final biometricEnabled = ref.watch(biometricEnabledProvider);
    final isDark = themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system && context.isDark);

    return Scaffold(
      appBar: const BSAppBar(
          title: AppStrings.settings, showBackButton: false),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.screenPadding),
        children: [
          // ── Account ───────────────────────────────────────────────────────
          _SettingsSection(
            title: AppStrings.settingsSectionAccount,
            children: [
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text(AppStrings.settingsProfile),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context
                    .showSnackBar(AppStrings.settingsProfileComingSoon),
              ),
              ListTile(
                leading: const Icon(Icons.diamond_outlined,
                    color: AppColors.gradientStart),
                title: const Text(AppStrings.premiumTitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/premium'),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.lg),

          // ── Preferences ───────────────────────────────────────────────────
          _SettingsSection(
            title: AppStrings.settingsSectionPreferences,
            children: [
              ListTile(
                leading: const Icon(Icons.notifications_outlined),
                title: const Text(AppStrings.settingsNotificationsLabel),
                trailing: Switch(
                  value: true,
                  onChanged: (v) {
                    // TODO: wire to notificationLeadDaysProvider when
                    // notification preferences UI is implemented.
                  },
                ),
              ),
              ListTile(
                leading: const Icon(Icons.dark_mode_outlined),
                title: const Text(AppStrings.settingsDarkMode),
                trailing: Switch(
                  value: isDark,
                  onChanged: (v) {
                    // Persist theme choice via SharedPreferences and
                    // update the Riverpod state so the whole app reacts.
                    final prefs = ref.read(sharedPreferencesProvider);
                    final newMode = v ? ThemeMode.dark : ThemeMode.light;
                    prefs.setString(
                      AppStrings.prefThemeMode,
                      v ? 'dark' : 'light',
                    );
                    ref.read(themeModeProvider.notifier).state = newMode;
                  },
                ),
              ),
              ListTile(
                leading: const Icon(Icons.fingerprint_rounded),
                title: const Text(AppStrings.settingsBiometric),
                trailing: Switch(
                  value: biometricEnabled,
                  onChanged: (v) {
                    final prefs = ref.read(sharedPreferencesProvider);
                    prefs.setBool(AppStrings.prefBiometricEnabled, v);
                    ref.read(biometricEnabledProvider.notifier).state = v;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.lg),

          // ── Data & Security ───────────────────────────────────────────────
          _SettingsSection(
            title: AppStrings.settingsSectionDataSecurity,
            children: [
              ListTile(
                leading: const Icon(Icons.cloud_sync_outlined),
                title: const Text(AppStrings.settingsSyncStatus),
                subtitle: const Text(AppStrings.settingsSyncLocalOnly),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/premium'),
              ),
              ListTile(
                leading: const Icon(Icons.download_rounded),
                title: const Text(AppStrings.settingsExportData),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context
                    .showSnackBar(AppStrings.settingsExportComingSoon),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.xl),

          // ── Sign Out ──────────────────────────────────────────────────────
          TextButton(
            onPressed: () {
              ref.read(authNotifierProvider.notifier).signOut();
              context.go('/auth/sign-in');
            },
            child: Text(
              AppStrings.signOut,
              style: GoogleFonts.inter(
                color: AppColors.statusDanger,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: AppSizes.xxl),

          // ── Version ───────────────────────────────────────────────────────
          Center(
            child: Text(
              '${AppStrings.appName} v${AppStrings.appVersion}',
              style: GoogleFonts.inter(
                color: context.textTertiary,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _SettingsSection
// ─────────────────────────────────────────────────────────────────────────────

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _SettingsSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8),
          child: Text(
            title,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              color: context.primaryTextColor,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: context.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.borderColor),
          ),
          child: Column(
            children: children.map((child) {
              return Column(
                children: [
                  child,
                  if (child != children.last)
                    Divider(
                      height: 1,
                      indent: 56,
                      color: context.borderColor,
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
