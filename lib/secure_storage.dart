import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static String sharedKey = 'encrypted_shared_key';
  static String presignKey = 'encrypted_presign_key';

  static saveEncryptedSharedKey(Uint8List encryptedSharedKey) async {
    const storage = FlutterSecureStorage();
    String s = String.fromCharCodes(encryptedSharedKey);
    await storage.write(key: sharedKey, value: s);
  }

  static Future<Uint8List?> readEncryptedSharedKey() async {
    const storage = FlutterSecureStorage();
    final s = await storage.read(key: sharedKey);
    if (s == null) {
      return null;
    }
    return Uint8List.fromList(s.codeUnits);
  }

  static deleteEncryptedSharedKey() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: sharedKey);
  }

  static saveEncryptedPresignKey(Uint8List encryptedPresignKey) async {
    const storage = FlutterSecureStorage();
    String s = String.fromCharCodes(encryptedPresignKey);
    await storage.write(key: sharedKey, value: s);
  }

  static Future<Uint8List?> readEncryptedPresignKey() async {
    const storage = FlutterSecureStorage();
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