import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:test_encrypt/encryption.dart';
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
  TextEditingController pinController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  Uint8List? hash;
  Uint8List? encryptedMessage;

  String? decryptedMessage;
  String errorText = '';

  @override
  void initState() {
    super.initState();
  }

  generateHash() async {
    hash = await Encryption().generateHashPassword(pinController.text);
    setState(() {});
  }

  encryptMessage() async {
    errorText = '';
    if (hash == null) {
      errorText = 'Pin belum di hash';
      setState(() {
        
      });
      return;
    }
    encryptedMessage = await Encryption().encryptSharedKey(
      hash!,
      Uint8List.fromList(messageController.text.codeUnits),
    );
    setState(() {});
  }

  decryptMessage() async {
    errorText = '';
    if (hash == null) {
      errorText = 'Pin belum di hash';
      setState(() {
        
      });
      return;
    }
    if (encryptedMessage == null) {
      errorText = 'Pesan belum di encrypt';
      setState(() {
        
      });
      return;
    }
    decryptedMessage = await Encryption().decryptSharedKey(hash!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(errorText, style: const TextStyle(color: Colors.red),),
              TextField(
                controller: pinController,
                decoration: const InputDecoration(
                  label: Text('Pin'),
                ),
              ),
              ElevatedButton(
                onPressed: generateHash,
                child: const Text('Generate Hash From Pin'),
              ),
              Text('Hash: ${(hash ?? "-").toString()}'),
              TextField(
                controller: messageController,
                decoration: const InputDecoration(
                  label: Text('Message'),
                ),
              ),
              ElevatedButton(
                onPressed: encryptMessage,
                child: const Text('Encrypt Message'),
              ),
              Text(
                  'Encrypted Message: ${(encryptedMessage ?? "-").toString()}'),
              ElevatedButton(
                onPressed: decryptMessage,
                child: const Text('Decrypt Message'),
              ),
              Text(
                  'Decrypted Message: ${(decryptedMessage ?? "-").toString()}'),
            ],
          ),
        ),
      ),
    );
  }
}
