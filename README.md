# test_encrypt

A new Flutter plugin project.

## Getting Started

Example:

```dart
    String message = 'message tes';
    String pin = '123456';

    Uint8List password = Uint8List.fromList(pin.codeUnits);
    Uint8List hash = await TestEncrypt.hashArgon2(password);

    Uint8List encryptedMessage = TestEncrypt.encryptSecretBox(
      hash,
      Uint8List.fromList(message.codeUnits),
    );

    String decryptedMessage = TestEncrypt.decryptScretBox(
      hash,
      encryptedMessage,
    );
    print(decryptedMessage);
```
