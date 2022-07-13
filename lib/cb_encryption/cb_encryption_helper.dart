import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter_hsm/flutter_hsm.dart';
import 'package:pinenacl/ed25519.dart';
import 'package:pinenacl/x25519.dart';
import 'package:test_encrypt/argon_encrypt.dart';
import 'package:test_encrypt/cb_encryption/cb_converter.dart';
import 'package:test_encrypt/cb_encryption/cb_secure_storage.dart';
import 'package:test_encrypt/salt.dart';
import 'package:test_encrypt/secret_box_encrypt.dart';

// const String ss_salt_key = 'generated_salt_key';

/// This is helper class for encryption
class CBEncryptionHelper {
  FlutterHardwareSecureModule fhsm = FlutterHardwareSecureModule();
  CBSecureStorage cbSecureStorage = CBSecureStorage();

  ///Create random salt
  ///Used for creating new PIN (application pin)
  Future<Salt> _generateNewSalt({String key = "salt"}) async {
    final newSalt = Salt.newSalt();
    //convert salt to string and save salt
    await cbSecureStorage.saveSalt(
        key, CBConverter.convertSaltToString(newSalt));
    return newSalt;
  }

  ///This action will generate new random salt
  ///Salt will be saved to local storate using [Secure Storage]
  ///Salt will used for generate new Hash
  ///and return HASHED PIN
  Future<Uint8List?>? generateHash(String pin) async {
    //Get new salt
    final salt = await _generateNewSalt(key: pin);
    //generate hashed pin using salt
    final hash = await ArgonEncrypt.generateHash(pin, salt);

    return hash;
  }

  /// Get hash will return Uint8List for the hashed PIN
  /// Salt will be load from secure storage
  /// the used for generate hash for the pin
  Future<Uint8List?>? getHash(String pin) async {
    Uint8List? hash;
    final salt = await cbSecureStorage.getSalt(pin);
    if (salt == null) {
      throw PlatformException(code: "password", message: "Password is wrong");
    } else {
      hash = await ArgonEncrypt.getHashByPassword(pin, Salt(salt.codeUnits));
    }
    return hash;
  }

  ///hash will be saved and encrypt with enclave (ios), tee(android)
  ///only if biometry is enrolled
  Future<void> encrptAndSaveHash(
      {required Uint8List hash, String tag = 'hash_tag'}) async {
    //Encrypt and get encrypted HASH
    final encrypted = await fhsm.encrypt(
      message: CBConverter.convertUint8ListToString(hash),
      accessControl: AccessControlHsm(
        authRequired: true,
        options: [AccessControlOption.biometryAny],
        tag: tag,
      ),
    );
    //Save Hash to Secure Storage
    await cbSecureStorage.save(
        tag, CBConverter.convertUint8ListToString(encrypted!));
  }

  ///Get Hash from storage then decrypt with hardware
  ///required biometry.
  Future<String>? loadAndDecryptHash({String tag = 'hash_tag'}) async {
    //load the encrypted hash
    final encryptedHash = await cbSecureStorage.load(tag);
    //decrypt using hardware
    final decrypted = await fhsm.decrypt(
      message: CBConverter.convertStringToUint8List(encryptedHash!),
      accessControl: AccessControlHsm(
        authRequired: true,
        options: [AccessControlOption.biometryAny],
        tag: tag,
      ),
    );

    return decrypted!;
  }

  ///This function will return layer 1 encryption
  ///layer 1 : encrypted message with hardware (enclave/strongbox/tee)
  Future<Uint8List> encryptAndSaveKey(
    Uint8List hash,
    String presignKey,
    String tag,
  ) async {
    //Encrypt with hardware
    final encrypted = await fhsm.encrypt(
      message: presignKey,
      accessControl: AccessControlHsm(
        authRequired: true,
        options: [AccessControlOption.privateKeyUsage],
        tag: tag,
      ),
    );
    //Encrypt using secret box with has as a key
    final hashed = SecretBoxEncrypt.hashMessage(hash, encrypted!);
    //Save the encrypted to secure storage
    await cbSecureStorage.save(tag, String.fromCharCodes(hashed));
    return encrypted;
  }

  //returned key is a encrypted key and only can be decrypt by hardware
  Future<String> loadEncryptedKey(Uint8List hash, String tag) async {
    log(hash.toString(), name: "Load ENcrypt Hash");
    //load hashed message from secure storage
    final hashedMessage = await cbSecureStorage.load(tag);
    final message = Uint8List.fromList(hashedMessage!.codeUnits);
    //decrypt and use hash as key

    final encrypted = SecretBoxEncrypt.decryptSecretBox(hash, message);

    return encrypted;
  }

  Future<String> decryptKeyWithHardware(String encrypted, String tag) async {
    //load hashed message from secure storage
    final newKey = CBConverter.convertStringToUint8List(encrypted);
    final decrypted = await fhsm.decrypt(
      message: newKey,
      accessControl: AccessControlHsm(
          authRequired: true,
          options: [
            AccessControlOption.privateKeyUsage,
          ],
          tag: tag),
    );

    return decrypted!;
  }
}
