import 'dart:convert';
import 'dart:math';

class RandomString {
  static final Random _random = Random.secure();

  static String createCryptoRandomString([int length = 32]) {
    var values = List<int>.generate(length, (index) => _random.nextInt(255));

    return base64Url.encode(values);
  }
}
