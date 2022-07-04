import 'dart:io';
import 'dart:typed_data';

import 'package:test_encrypt/secure_storage.dart';

import 'argon_encrypt.dart';

import 'secret_box_encrypt.dart';

class Encryption {
  Future<Uint8List> generateHashPassword(String pin) async {
    Uint8List hash = await ArgonEncrypt.generateHash(pin);
    return hash;
  }

  Future<Uint8List> encryptSharedKey(Uint8List passwordHash, Uint8List message) async {
    Uint8List encryptedMessage = SecretBoxEncrypt.hashMessage(
      passwordHash,
      message,
    );

    await SecureStorage.saveEncryptedSharedKey(encryptedMessage);

    return encryptedMessage;
  }

  Future<Uint8List> encryptPresignKey(Uint8List passwordHash, Uint8List message) async {
    Uint8List encryptedMessage = SecretBoxEncrypt.hashMessage(
      passwordHash,
      message,
    );

    await SecureStorage.saveEncryptedPresignKey(encryptedMessage);

    return encryptedMessage;
  }

  Future<String> decryptSharedKey(Uint8List hash) async {
    // Uint8List hash = await ArgonEncrypt.generateHash(pin);
    final encryptedSharedKey = await SecureStorage.readEncryptedSharedKey();
    return SecretBoxEncrypt.decryptSecretBox(hash, encryptedSharedKey!);
  }

  Future<String> decryptPresignKey(String pin) async {
    Uint8List hash = await ArgonEncrypt.generateHash(pin);
    final encryptedSharedKey = await SecureStorage.readEncryptedSharedKey();
    return SecretBoxEncrypt.decryptSecretBox(hash, encryptedSharedKey!);
  }
}