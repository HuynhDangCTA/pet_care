
import 'dart:convert';

import 'package:crypto/crypto.dart';

class EncodeUtil {
  static String generateSHA256(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}