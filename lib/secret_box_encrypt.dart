import 'dart:developer';
import 'dart:math';
import 'package:pinenacl/api.dart';

import 'package:pinenacl/x25519.dart';
import 'package:test_encrypt/argon_encrypt.dart';
import 'package:test_encrypt/salt.dart';

class SecretBoxEncrypt {
  static Future<Uint8List> encryptKeyWithCustomHash(
      Uint8List key, String hashTag) async {
    final _hash =
        await ArgonEncrypt.generateHashWithSalt(hashTag, Salt.newSalt());
    final box = SecretBox(_hash);
    final encrypted = box.encrypt(key);
    return encrypted.toUint8List();
  }

  static Uint8List hashMessage(Uint8List hash, Uint8List message) {
    final box = SecretBox(hash);
    final encrypted = box.encrypt(message);
    return encrypted.toUint8List();
  }

  static String decryptSecretBox(Uint8List hash, Uint8List encryptedMessage) {
    // final encrypted = EncryptedMessage.fromList(encryptedMessage);
    final box = SecretBox(hash);
    // final decrypted = box.decrypt(encrypted);
    // return String.fromCharCodes(decrypted);

    var bytelistencryptedMessage = ByteList(
      encryptedMessage,
    );
    final takenonce =
        bytelistencryptedMessage.take(EncryptedMessage.nonceLength);
    final chipherTextnonce =
        bytelistencryptedMessage.skip(EncryptedMessage.nonceLength);
    ByteList nonce = ByteList.withConstraint(
      takenonce,
      constraintLength: EncryptedMessage.nonceLength,
    );
    ByteList chipherText = ByteList.withConstraint(chipherTextnonce,
        constraintLength:
            bytelistencryptedMessage.length - EncryptedMessage.nonceLength);

    final decrypted = box.decrypt(
      EncryptedMessage(
        nonce: nonce.asTypedList,
        cipherText: chipherText.asTypedList,
      ),
    );

    final plaintext = String.fromCharCodes(decrypted);

    return plaintext;
  }
}
