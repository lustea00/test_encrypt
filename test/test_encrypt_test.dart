// import 'package:flutter_test/flutter_test.dart';
// import 'package:test_encrypt/test_encrypt.dart';
// import 'package:test_encrypt/test_encrypt_platform_interface.dart';
// import 'package:test_encrypt/test_encrypt_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// class MockTestEncryptPlatform 
//     with MockPlatformInterfaceMixin
//     implements TestEncryptPlatform {

//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }

// void main() {
//   final TestEncryptPlatform initialPlatform = TestEncryptPlatform.instance;

//   test('$MethodChannelTestEncrypt is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelTestEncrypt>());
//   });

//   test('getPlatformVersion', () async {
//     TestEncrypt testEncryptPlugin = TestEncrypt();
//     MockTestEncryptPlatform fakePlatform = MockTestEncryptPlatform();
//     TestEncryptPlatform.instance = fakePlatform;
  
//     // expect(await testEncryptPlugin.getPlatformVersion(), '42');
//   });
// }
