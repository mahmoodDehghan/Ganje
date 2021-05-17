import 'package:test/test.dart';
import '../../../lib/helpers/cryption/cryptionhelper.dart';

void main() {
  group('generate rsa key pair test', () {
    test('create random secure randoms', () {
      var rs1 = CryptionHelper.createRandomSecure();
      var rs2 = CryptionHelper.createRandomSecure();
      expect(rs1 != rs2, isTrue);
    });
    test('create any rsa assymetric key with  private key', () {
      expect(CryptionHelper.generateRsaKey().privateKey, isNotNull);
    });
    test('create any rsa assymetric key with  private key', () {
      expect(CryptionHelper.generateRsaKey().publicKey, isNotNull);
    });
  });
}
