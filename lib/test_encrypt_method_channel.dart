import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'test_encrypt_platform_interface.dart';

/// An implementation of [TestEncryptPlatform] that uses method channels.
class MethodChannelTestEncrypt extends TestEncryptPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('test_encrypt');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
