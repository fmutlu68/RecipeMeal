import 'dart:convert';
import 'dart:typed_data';

class Utility {
  /// Convert [String] To [Uint8List]
  static Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  /// Convert [Uint8List] To [String]
  static String base64String(Uint8List data) {
    return base64Encode(data);
  }
}
