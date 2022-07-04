library test_encrypt;

import 'salt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pinenacl/x25519.dart';
import 'package:pointycastle/key_derivators/argon2_native_int_impl.dart';
import 'package:pointycastle/pointycastle.dart';

class TestEncrypt {
  static Future<Uint8List> hashArgon2(Uint8List password) async {
    Salt salt = await _generateAndSaveSalt();

    var parameters = Argon2Parameters(
      Argon2Parameters.ARGON2_id,
      Uint8List.fromList(salt.bytes),
      desiredKeyLength: 32,
      version: Argon2Parameters.ARGON2_VERSION_13,
      iterations: 2,
      lanes: 1, // Parallelism Factor
      memory: 256,
    );

    var gen = Argon2BytesGenerator();
    gen.init(parameters);

    var passwordBytes = Uint8List.fromList(password);

    var result = gen.process(passwordBytes);

    return result;
  }

  static Uint8List encryptSecretBox(Uint8List hash, Uint8List message) {
    final box = SecretBox(hash);
    final encrypted = box.encrypt(message);
    return encrypted.toUint8List();
  }

  static String decryptScretBox(Uint8List hash, Uint8List encryptedMessage) {
    final encrypted = EncryptedMessage.fromList(encryptedMessage);
    final box = SecretBox(hash);
    final decrypted = box.decrypt(encrypted);
    return String.fromCharCodes(decrypted);
  }

  static Future<Salt> _generateAndSaveSalt() async {
    const storage = FlutterSecureStorage();
    Salt salt = Salt.newSalt();
    String s = String.fromCharCodes(salt.bytes);
    await storage.write(key: 'generated_salt', value: s);
    return salt;
  }
}
