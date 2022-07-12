import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CBSecureStorage {
  String sharedKey = 'encrypted_shared_key';
  String presignKey = 'encrypted_presign_key';
  final storage = FlutterSecureStorage();
  

  Future<void> saveSalt(String key, String generatedSalt) async {
    try {
      await storage.write(key: key, value: generatedSalt);
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  Future<String?> getSalt(String key) async {
    try {
      final salt = await storage.read(key: key);
      return salt;
    } on Exception catch (e) {
      throw Exception("No Salt Found");
    }
  }

  Future<String?> removeSalt() async {
    try {
      await storage.delete(key: 'generated_salt');
    } on Exception catch (e) {
      throw Exception("No Salt Found");
    }
  }

  saveEncryptedSharedKey(Uint8List encryptedSharedKey) async {
    String s = String.fromCharCodes(encryptedSharedKey);
    await storage.write(key: sharedKey, value: s);
  }

  Future<Uint8List?> readEncryptedSharedKey() async {
    final s = await storage.read(key: sharedKey);
    if (s == null) {
      return null;
    }
    return Uint8List.fromList(s.codeUnits);
  }

  deleteEncryptedSharedKey() async {
    await storage.delete(key: sharedKey);
  }

  saveEncryptedPresignKey(Uint8List encryptedPresignKey) async {
    String s = String.fromCharCodes(encryptedPresignKey);
    await storage.write(key: presignKey, value: s);
  }

  save(String key, String value) async {
    await storage.write(key: key, value: value);
  }

  Future<String?> load(String key) async {
    final result = await storage.read(key: key);
    return result;
  }

  Future<Uint8List?> readEncryptedPresignKey() async {
    final s = await storage.read(key: presignKey);
    if (s == null) {
      return null;
    }
    return Uint8List.fromList(s.codeUnits);
  }

  deleteEncryptedPresignKey() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: presignKey);
  }
}
