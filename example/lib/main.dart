import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:test_encrypt/test_encrypt.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    encypt();
    super.initState();
  }

  void encypt() async {
    String message = 'message tes';
    String pin = '123456';

    Uint8List password = Uint8List.fromList(pin.codeUnits);
    Uint8List hash = await TestEncrypt.hashArgon2(password);

    Uint8List encryptedMessage =
    TestEncrypt.encryptSecretBox(hash, Uint8List.fromList(message.codeUnits),);

    String decryptedMessage = TestEncrypt.decryptScretBox(hash, encryptedMessage);
    print(decryptedMessage);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on:'),
        ),
      ),
    );
  }
}
