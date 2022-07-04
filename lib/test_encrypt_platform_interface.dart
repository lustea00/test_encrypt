import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'test_encrypt_method_channel.dart';

abstract class TestEncryptPlatform extends PlatformInterface {
  /// Constructs a TestEncryptPlatform.
  TestEncryptPlatform() : super(token: _token);

  static final Object _token = Object();

  static TestEncryptPlatform _instance = MethodChannelTestEncrypt();

  /// The default instance of [TestEncryptPlatform] to use.
  ///
  /// Defaults to [MethodChannelTestEncrypt].
  static TestEncryptPlatform get instance => _instance;
  
  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [TestEncryptPlatform] when
  /// they register themselves.
  static set instance(TestEncryptPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
