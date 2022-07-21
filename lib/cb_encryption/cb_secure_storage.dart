import 'dart:typed_data';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CBSecureStorage {
  static final CBSecureStorage _singleton = CBSecureStorage._internal();

  factory CBSecureStorage() {
    return _singleton;
  }

  CBSecureStorage._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  IOSOptions _getIOSOptions() => const IOSOptions();

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: false,
      );

  String sharedKey = 'encrypted_shared_key';
  String presignKey = 'encrypted_presign_key';

  Future<void> saveSalt(String key, String generatedSalt) async {
    try {
      await _storage.write(
        key: key,
        value: generatedSalt,
        iOptions: _getIOSOptions(),
        aOptions: _getAndroidOptions(),
      );
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  Future<String?> getSalt(String key) async {
    try {
      final salt = await _storage.read(
        key: key,
        iOptions: _getIOSOptions(),
        aOptions: _getAndroidOptions(),
      );
      return salt;
    } on Exception catch (e) {
      throw Exception("No Salt Found");
    }
  }

  Future<String?> removeSalt() async {
    try {
      await _storage.delete(
        key: 'generated_salt',
        iOptions: _getIOSOptions(),
        aOptions: _getAndroidOptions(),
      );
    } on Exception catch (e) {
      throw Exception("No Salt Found");
    }
  }

  saveEncryptedSharedKey(Uint8List encryptedSharedKey) async {
    String s = String.fromCharCodes(encryptedSharedKey);
    await _storage.write(
      key: sharedKey,
      value: s,
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
  }

  Future<Uint8List?> readEncryptedSharedKey() async {
    final s = await _storage.read(
      key: sharedKey,
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
    if (s == null) {
      return null;
    }
    return Uint8List.fromList(s.codeUnits);
  }

  deleteEncryptedSharedKey() async {
    await _storage.delete(
      key: sharedKey,
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
  }

  saveEncryptedPresignKey(Uint8List encryptedPresignKey) async {
    String s = String.fromCharCodes(encryptedPresignKey);
    await _storage.write(
      key: presignKey,
      value: s,
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
  }

  save(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> load(String key) async {
    final result = await _storage.read(
      key: key,
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
    var s = await _storage.readAll(
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
    return result;
  }

  Future<Uint8List?> readEncryptedPresignKey() async {
    final s = await _storage.read(
      key: presignKey,
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
    if (s == null) {
      return null;
    }
    return Uint8List.fromList(s.codeUnits);
  }

  deleteEncryptedPresignKey() async {
    await _storage.delete(
      key: presignKey,
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
  }
}
