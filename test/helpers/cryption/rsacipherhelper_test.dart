import 'package:test/test.dart';

import '../../../lib/helpers/cryption/rsacipherhelper.dart';
import '../../../lib/helpers/cryption/cryptionhelper.dart';

import '../../../lib/models/cryption/rsakey.dart';

void main() {
  var rsaKey = RsaKey(CryptionHelper.generateRsaKey());
  var testString = 'Hello';
  var rsaCipher = RsaCipherHelper(rsaKey);
  var rsaCipher2 = RsaCipherHelper(RsaKey(CryptionHelper.generateRsaKey()));
  group('rsa cipher functions tests', () {
    test('RSA signed data test', () {
      expect(rsaCipher.rsaSign(testString) == testString, isFalse);
    });
    test('test verify signed data with RSA key', () {
      expect(rsaCipher.rsaVerify(testString, rsaCipher.rsaSign(testString)),
          isTrue);
    });
    test('wrong key RSA verify test', () {
      expect(rsaCipher2.rsaVerify(testString, rsaCipher.rsaSign(testString)),
          isFalse);
    });
    test('RSA decrypt test', () {
      expect(
          rsaCipher.rsaDecrypt(rsaCipher.rsaEncrypt(testString)), testString);
    });
    test('RSA decrypt with wrong key test', () {
      var enc = rsaCipher.rsaEncrypt(testString);
      expect(() => rsaCipher2.rsaDecrypt(enc), throwsArgumentError);
    });
    test('simple RSA encrypt test', () {
      expect(rsaCipher.rsaEncrypt(testString) == testString, isFalse);
    });
  });
}
