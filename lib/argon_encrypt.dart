import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pinenacl/x25519.dart';
import 'package:pointycastle/key_derivators/argon2.dart';
import 'package:pointycastle/pointycastle.dart';
import 'package:test_encrypt/salt.dart';

class ArgonEncrypt {
  static Future<Uint8List> generateHash(String password) async {
    Uint8List pin = Uint8List.fromList(password.codeUnits);
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

    var passwordBytes = Uint8List.fromList(pin);

    var result = gen.process(passwordBytes);

    return result;
  }

  static Future<Salt> _generateAndSaveSalt() async {
    const storage = FlutterSecureStorage();
    Salt salt = Salt.newSalt();
    String s = String.fromCharCodes(salt.bytes);
    await storage.write(key: 'generated_salt', value: s);
    return salt;
  }
}
