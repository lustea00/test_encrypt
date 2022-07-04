import 'package:pinenacl/x25519.dart';

class SecretBoxEncrypt {
  static Uint8List hashMessage(Uint8List hash, Uint8List message) {
    final box = SecretBox(hash);
    final encrypted = box.encrypt(message);
    return encrypted.toUint8List();
  }

  static String decryptSecretBox(Uint8List hash, Uint8List encryptedMessage) {
    final encrypted = EncryptedMessage.fromList(encryptedMessage);
    final box = SecretBox(hash);
    final decrypted = box.decrypt(encrypted);
    return String.fromCharCodes(decrypted);
  }
}
