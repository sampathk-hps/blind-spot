import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as enc;

class EncryptionService {
  EncryptionService._();
  static final EncryptionService instance = EncryptionService._();

  enc.Encrypter? _encrypter;
  bool get isInitialized => _encrypter != null;

  void initialize(String base64Key) {
    final key = enc.Key.fromBase64(base64Key);
    _encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
  }

  static String generateKey() {
    final secureRandom = Random.secure();
    final keyBytes = Uint8List(32);
    for (int i = 0; i < 32; i++) {
      keyBytes[i] = secureRandom.nextInt(256);
    }
    return base64.encode(keyBytes);
  }

  String encrypt(String plaintext) {
    if (!isInitialized) throw StateError('EncryptionService not initialized');
    final iv = enc.IV.fromSecureRandom(16);
    final encrypted = _encrypter!.encrypt(plaintext, iv: iv);
    return '${iv.base64}:${encrypted.base64}';
  }

  String decrypt(String ciphertext) {
    if (!isInitialized) throw StateError('EncryptionService not initialized');
    final parts = ciphertext.split(':');
    if (parts.length != 2) throw ArgumentError('Invalid ciphertext format');
    
    final iv = enc.IV.fromBase64(parts[0]);
    final encrypted = enc.Encrypted.fromBase64(parts[1]);
    return _encrypter!.decrypt(encrypted, iv: iv);
  }

  String? encryptNullable(String? plaintext) {
    if (plaintext == null) return null;
    return encrypt(plaintext);
  }

  String? decryptNullable(String? ciphertext) {
    if (ciphertext == null) return null;
    return decrypt(ciphertext);
  }
}
