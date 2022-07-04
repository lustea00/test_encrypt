import 'dart:math';


class Salt {
  final List<int> _bytes;

  Salt(this._bytes);

  factory Salt.newSalt({int length = 16}) {
    return Salt(_getRandomBytes(16));
  }

  static List<int> _getRandomBytes([int length = 16]) {
    final random = Random.secure();
    return List<int>.generate(length, (i) => random.nextInt(256));
  }

  List<int> get bytes {
    return _bytes;
  }
}
