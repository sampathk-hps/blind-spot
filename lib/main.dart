import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:blindspot/app/app.dart';
import 'package:blindspot/core/constants/app_strings.dart';
import 'package:blindspot/core/di/providers.dart';
import 'package:blindspot/core/security/encryption_service.dart';
import 'package:blindspot/core/storage/hive_service.dart';
import 'package:blindspot/core/storage/secure_storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize secure storage (iOS Keychain / Android Keystore)
  SecureStorageService.instance.initialize();

  // 2. Initialize Hive with AES encryption key stored in secure storage
  await HiveService.instance.initialize();

  // 3. Initialize AES-256 encryption service
  await _initEncryptionService();

  // 4. Initialize Firebase
  // TODO: Add google-services.json (Android) and GoogleService-Info.plist (iOS)
  //       from your Firebase project console before enabling Firebase features.
  await _initFirebase();

  // 5. Load SharedPreferences — synchronously available after this point
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        // Inject the concrete SharedPreferences instance so all providers
        // that depend on [sharedPreferencesProvider] can read persisted state.
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const BlindSpotApp(),
    ),
  );
}

/// Reads or generates the AES-256 key from secure storage, then initialises
/// [EncryptionService] so it is ready before any data access occurs.
Future<void> _initEncryptionService() async {
  final storage = SecureStorageService.instance;
  String? key = await storage.read(key: AppStrings.secureKeyAesEncryption);
  if (key == null) {
    key = EncryptionService.generateKey();
    await storage.write(
      key: AppStrings.secureKeyAesEncryption,
      value: key,
    );
  }
  EncryptionService.instance.initialize(key);
}

/// Attempts to initialise Firebase. Fails silently if the project configuration
/// files have not yet been added (common during early development).
Future<void> _initFirebase() async {
  try {
    await Firebase.initializeApp();
  } catch (e) {
    // Firebase is not configured yet.
    // Add google-services.json and GoogleService-Info.plist to enable.
    debugPrint('[BlindSpot] Firebase not configured: $e');
  }
}
