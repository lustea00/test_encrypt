import 'package:pinenacl/ed25519.dart';

class UploadResponse {
  Uint8List hash;
  Uint8List encrypted;
  UploadResponse(this.hash, this.encrypted);
}
