import 'dart:convert';
import 'dart:typed_data';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:blindspot/core/constants/app_strings.dart';
import 'package:blindspot/core/storage/secure_storage_service.dart';

class HiveService {
  HiveService._();
  static final HiveService instance = HiveService._();

  Future<void> initialize() async {
    await Hive.initFlutter();

    final encryptionKey = await _getOrCreateHiveKey();
    final cipher = HiveAesCipher(encryptionKey);

    await Hive.openBox<Map>(AppStrings.hiveBoxInvoices, encryptionCipher: cipher);
    await Hive.openBox<Map>(AppStrings.hiveBoxInsurances, encryptionCipher: cipher);
    await Hive.openBox<Map>(AppStrings.hiveBoxSubscriptions, encryptionCipher: cipher);
    
    await Hive.openBox<dynamic>(AppStrings.hiveBoxUserPrefs, encryptionCipher: cipher);
    await Hive.openBox<dynamic>(AppStrings.hiveBoxNotificationSettings, encryptionCipher: cipher);
  }

  Box<Map> box(String name) => Hive.box<Map>(name);
  Box<dynamic> prefsBox() => Hive.box<dynamic>(AppStrings.hiveBoxUserPrefs);
  Box<dynamic> notificationBox() => Hive.box<dynamic>(AppStrings.hiveBoxNotificationSettings);

  Future<Uint8List> _getOrCreateHiveKey() async {
    final storage = SecureStorageService.instance;
    String? base64Key = await storage.read(key: AppStrings.secureKeyHiveEncryption);
    
    if (base64Key == null) {
      final key = Hive.generateSecureKey();
      base64Key = base64UrlEncode(key);
      await storage.write(key: AppStrings.secureKeyHiveEncryption, value: base64Key);
      return Uint8List.fromList(key);
    }
    
    return base64Url.decode(base64Key);
  }
}
