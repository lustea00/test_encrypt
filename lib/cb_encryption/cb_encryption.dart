import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter_hsm/flutter_hsm.dart';
import 'package:pinenacl/ed25519.dart';
import 'package:pinenacl/x25519.dart';
import 'package:secure_enclave/secure_enclave.dart';
import 'package:test_encrypt/argon_encrypt.dart';
import 'package:test_encrypt/encryption.dart';
import 'package:test_encrypt/salt.dart';
import 'package:test_encrypt/secret_box_encrypt.dart';
import 'package:test_encrypt/secure_storage.dart';

class CBEncryption {
  Encryption encryption = Encryption();
  SecureEnclave secureEnclave = SecureEnclave();

  Future<Uint8List?>? getHash(String pin) async {
    final salt = await SecureStorage.getSalt(pin);
    Uint8List? hash;
    if (salt == null) {
      //Password Wrong
      throw PlatformException(code: "password", message: "Password is wrong");
    } else {
      hash = await ArgonEncrypt.getHashByPassword(pin, Salt(salt.codeUnits));
    }
    return hash;
  }

  Future<Uint8List?>? generateHash(String pin) async {
    final hash = await ArgonEncrypt.generateHash(pin);
    print(hash);
    return hash;
  }

  ///Fixing tag soon
  Future<void> saveAndEncryptHash(
      {required Uint8List hash, String tag = 'hash_tag'}) async {
    final encrypted = await secureEnclave.encrypt(
      message: String.fromCharCodes(hash),
      accessControl: AccessControlHsm(
        options: [AccessControlOption.privateKeyUsage],
        tag: tag,
      ),
    );

    await SecureStorage.save(tag, String.fromCharCodes(encrypted.value!));
  }

  ///Remove tag soon
  Future<String>? loadAndDecryptHash({String tag = 'hash_tag'}) async {
    final encryptedHash = await SecureStorage.load(tag);

    final decrypted = await secureEnclave.decrypt(
      message: Uint8List.fromList(encryptedHash!.codeUnits),
      accessControl: AccessControlHsm(
        options: [AccessControlOption.biometryAny],
        tag: tag,
      ),
    );

    return decrypted.value!;
  }

  Future<void> saveAndEcnryptPresignKey(
      Uint8List hash, Uint8List presignKey) async {
    String decrypted = String.fromCharCodes(presignKey);

    final encrypted = await SecureEnclave().encrypt(
      message: decrypted,
      accessControl: AccessControl(options: [
        AccessControlOption.privateKeyUsage,
      ], tag: 'presign_key_tag'),
    );

    //Encrypt using hash
    final hashed = SecretBoxEncrypt.hashMessage(hash, encrypted.value!);

    await SecureStorage.saveEncryptedPresignKey(hashed);
  }

  Future<String> loadEncryptedPresignKey(Uint8List hash) async {
    //load hashed message from secure storage
    final hashedMessage = await SecureStorage.readEncryptedPresignKey();
    log(hashedMessage.toString(), name: "Hashed Message");
    final encrypted = SecretBoxEncrypt.decryptSecretBox(hash, hashedMessage!);
    log(encrypted, name: " Encrypted");
    return encrypted;
  }

  Future<String> decryptPresignKeyWithEnclave(
      String encryptedPresignKey) async {
    //load hashed message from secure storage

    final decrypted = await SecureEnclave().decrypt(
      message: Uint8List.fromList(encryptedPresignKey.codeUnits),
      accessControl: AccessControl(options: [
        AccessControlOption.privateKeyUsage,
      ], tag: 'presign_key_tag'),
    );

    return decrypted.value!;
  }
}
