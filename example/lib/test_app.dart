// import 'dart:developer';
// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:test_encrypt/cb_encryption/encryption.dart';

// class TestApp extends StatefulWidget {
//   const TestApp({Key? key}) : super(key: key);

//   @override
//   State<TestApp> createState() => _TestAppState();
// }

// class _TestAppState extends State<TestApp> {
//   Uint8List? hash;
//   String? encryptedPresignKey;
//   String? keyWantToSecure = "This is key lol hahahah";
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Container(
//         child: Column(
//           children: [
//             ElevatedButton(
//               onPressed: () async {
//                 String pin = '123456';
//                 CBEncryption cbEncryption = CBEncryption();
//                 try {
//                   hash = await cbEncryption.generateHash(pin);
//                 } on PlatformException catch (e) {
//                   print(e);
//                 }

//                 print(hash);
//               },
//               child: Text("Generate Hash + Save Salt (123456)"),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 String pin = '123456';
//                 CBEncryption cbEncryption = CBEncryption();
//                 try {
//                   hash = await cbEncryption.getHash(pin);

//                   print(hash);
//                 } on PlatformException catch (e) {
//                   log(e.message.toString());
//                 }
//               },
//               child: Text("Get Hash Using Right PIN"),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 String pin = 'false';
//                 CBEncryption cbEncryption = CBEncryption();
//                 try {
//                   hash = await cbEncryption.getHash(pin);
//                   print(hash);
//                 } on PlatformException catch (e) {
//                   log(e.message.toString());
//                 }
//               },
//               child: Text("Get Hash Using Wrong PIN"),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 CBEncryption cbEncryption = CBEncryption();
//                 await cbEncryption
//                     .saveAndEcnryptPresignKey(
//                         hash!, Uint8List.fromList(keyWantToSecure!.codeUnits))
//                     .then((value) => print("Key Save To Enclave"));
//               },
//               child: Text("Encrypt Data (keyencrypt)"),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 CBEncryption cbEncryption = CBEncryption();
//                 encryptedPresignKey =
//                     await cbEncryption.loadEncryptedPresignKey(hash!);
//               },
//               child: Text("Load Encrypted Data (keyencrypt)"),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 CBEncryption cbEncryption = CBEncryption();
//                 await cbEncryption
//                     .decryptPresignKeyWithEnclave(encryptedPresignKey!)
//                     .then((value) => print(value));
//               },
//               child: Text("Decrypt Encrypted Data (keyencrypt)"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
