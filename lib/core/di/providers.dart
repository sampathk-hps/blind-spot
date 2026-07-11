import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:blindspot/core/security/encryption_service.dart';
import 'package:blindspot/core/storage/hive_service.dart';
import 'package:blindspot/core/storage/secure_storage_service.dart';
import 'package:blindspot/core/constants/app_strings.dart';
import 'package:blindspot/shared/models/user_tier.dart';

// ─────────────────────────────────────────────────────────────────────────────
// 1. SharedPreferences — overridden in main.dart before runApp
// ─────────────────────────────────────────────────────────────────────────────
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError(
    'sharedPreferencesProvider must be overridden in ProviderScope before runApp.',
  ),
);

// ─────────────────────────────────────────────────────────────────────────────
// 2. Theme Mode
// ─────────────────────────────────────────────────────────────────────────────
final themeModeProvider = StateProvider<ThemeMode>((ref) {
  final prefs = ref.read(sharedPreferencesProvider);
  final saved = prefs.getString(AppStrings.prefThemeMode);
  switch (saved) {
    case 'light':
      return ThemeMode.light;
    case 'dark':
      return ThemeMode.dark;
    default:
      return ThemeMode.system;
  }
});

// ─────────────────────────────────────────────────────────────────────────────
// 3. User Tier
// ─────────────────────────────────────────────────────────────────────────────
final userTierProvider = StateProvider<UserTier>((ref) {
  final prefs = ref.read(sharedPreferencesProvider);
  final saved = prefs.getString(AppStrings.prefUserTier);
  return UserTier.fromString(saved);
});

// ─────────────────────────────────────────────────────────────────────────────
// 4. Premium shorthand
// ─────────────────────────────────────────────────────────────────────────────
final isPremiumProvider = Provider<bool>(
  (ref) => ref.watch(userTierProvider).isPremium,
);

// ─────────────────────────────────────────────────────────────────────────────
// 5. EncryptionService singleton
// ─────────────────────────────────────────────────────────────────────────────
final encryptionServiceProvider = Provider<EncryptionService>(
  (ref) => EncryptionService.instance,
);

// ─────────────────────────────────────────────────────────────────────────────
// 6. HiveService singleton
// ─────────────────────────────────────────────────────────────────────────────
final hiveServiceProvider = Provider<HiveService>(
  (ref) => HiveService.instance,
);

// ─────────────────────────────────────────────────────────────────────────────
// 7. SecureStorageService singleton
// ─────────────────────────────────────────────────────────────────────────────
final secureStorageProvider = Provider<SecureStorageService>(
  (ref) => SecureStorageService.instance,
);

// ─────────────────────────────────────────────────────────────────────────────
// 8. Biometric auth enabled flag
// ─────────────────────────────────────────────────────────────────────────────
final biometricEnabledProvider = StateProvider<bool>((ref) {
  final prefs = ref.read(sharedPreferencesProvider);
  return prefs.getBool(AppStrings.prefBiometricEnabled) ?? false;
});

// ─────────────────────────────────────────────────────────────────────────────
// 9. Notification lead days
// ─────────────────────────────────────────────────────────────────────────────
final notificationLeadDaysProvider = StateProvider<int>((ref) {
  final prefs = ref.read(sharedPreferencesProvider);
  return prefs.getInt(AppStrings.prefNotificationLeadTime) ?? 7;
});
