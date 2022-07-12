import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:test_encrypt/cb_encryption/cb_encryption.dart';
import 'package:test_encrypt/encryption.dart';
import 'package:test_encrypt/test_encrypt.dart';
import 'package:test_encrypt_example/test_app.dart';

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
  Widget build(BuildContext context) {
    return MaterialApp(home: TestApp());
  }
}
