import 'package:pinenacl/api.dart';
import 'package:test_encrypt/salt.dart';

class CBConverter {
  static String convertSaltToString(Salt salt) {
    return String.fromCharCodes(salt.bytes);
  }

  static Salt convertStringToSalt(String data) {
    final uint = convertStringToUint8List(data);
    return Salt(uint);
  }

  static Uint8List convertStringToUint8List(String data) {
    return Uint8List.fromList(data.codeUnits);
  }

  static String convertUint8ListToString(Uint8List data) {
    return String.fromCharCodes(data);
  }
}
