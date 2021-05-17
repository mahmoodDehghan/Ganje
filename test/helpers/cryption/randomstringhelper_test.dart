import 'package:test/test.dart';
import '../../../lib/helpers/cryption/randomstringhelper.dart';

void main() {
  group('generate random string', () {
    test('generate different random strings', () {
      expect(
          RandomString.createCryptoRandomString() ==
              RandomString.createCryptoRandomString(),
          isFalse);
    });
  });
}
