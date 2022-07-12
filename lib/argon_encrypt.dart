import 'dart:typed_data';

import 'package:pinenacl/x25519.dart';
import 'package:pointycastle/key_derivators/argon2.dart';
import 'package:pointycastle/pointycastle.dart';
import 'package:test_encrypt/salt.dart';

class ArgonEncrypt {
  static Future<Uint8List> getHashByPassword(String password, Salt salt) async {
    Uint8List pin = Uint8List.fromList(password.codeUnits);
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

  static Future<Uint8List> generateHash(String password, Salt salt) async {
    Uint8List pin = Uint8List.fromList(password.codeUnits);

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

  static Future<Uint8List> generateHashWithSalt(
      String password, Salt salt) async {
    Uint8List pin = Uint8List.fromList(password.codeUnits);

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

  // static Future<Salt> _generateAndSaveSalt(String password) async {
  //   //check if saved salt with password already exist
  //   final saltString = await SecureStorage.getSalt(password);
  //   Salt newSalt;
  //   if (saltString == null) {
  //     newSalt = Salt.newSalt();
  //   } else {
  //     newSalt = Salt(saltString.codeUnits);
  //   }

  //   String s = String.fromCharCodes(newSalt.bytes);
  //   await CBSecureStorage.saveSalt(password, s);
  //   return newSalt;
  // }
}
