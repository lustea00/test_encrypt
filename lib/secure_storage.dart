import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static String sharedKey = 'encrypted_shared_key';
  static String presignKey = 'encrypted_presign_key';
  static const storage = FlutterSecureStorage();

  static Future<void> saveSalt(String key, String generatedSalt) async {
    try {
      await storage.write(key: key, value: generatedSalt);
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  static Future<String?> getSalt(String key) async {
    try {
      final salt = await storage.read(key: key);

      return salt;
    } on Exception catch (e) {
      throw Exception("No Salt Found");
    }
  }

  static Future<String?> removeSalt() async {
    try {
      await storage.delete(key: 'generated_salt');
    } on Exception catch (e) {
      throw Exception("No Salt Found");
    }
  }

  static saveEncryptedSharedKey(Uint8List encryptedSharedKey) async {
    String s = String.fromCharCodes(encryptedSharedKey);
    await storage.write(key: sharedKey, value: s);
  }

  static Future<Uint8List?> readEncryptedSharedKey() async {
    final s = await storage.read(key: sharedKey);
    if (s == null) {
      return null;
    }
    return Uint8List.fromList(s.codeUnits);
  }

  static deleteEncryptedSharedKey() async {
    await storage.delete(key: sharedKey);
  }

  static saveEncryptedPresignKey(Uint8List encryptedPresignKey) async {
    String s = String.fromCharCodes(encryptedPresignKey);
    await storage.write(key: presignKey, value: s);
  }

  static save(String key, String value) async {
    await storage.write(key: key, value: value);
  }

  static Future<String?> load(String key) async {
    final result = await storage.read(key: key);
    return result;
  }

  static Future<Uint8List?> readEncryptedPresignKey() async {
    final s = await storage.read(key: presignKey);
    if (s == null) {
      return null;
    }
    return Uint8List.fromList(s.codeUnits);
  }

  static deleteEncryptedPresignKey() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: presignKey);
  }
}
