import 'package:test/test.dart';

import '../../../lib/helpers/cryption/cryptionhelper.dart';
import '../../../lib/models/cryption/rsakey.dart';

void main() {
  group('rsa model map tests', () {
    test('convert model to map', () {
      RsaKey key = RsaKey(CryptionHelper.generateRsaKey());
      var testMap = key.toStringMap;
      bool hasAllElements = testMap[RsaKey.privateExpLabel]!.isNotEmpty &&
          testMap[RsaKey.privateModLabel]!.isNotEmpty &&
          testMap[RsaKey.privateNLabel]!.isNotEmpty &&
          testMap[RsaKey.privatePLabel]!.isNotEmpty &&
          testMap[RsaKey.privateQLabel]!.isNotEmpty &&
          testMap[RsaKey.publicExpLabel]!.isNotEmpty &&
          testMap[RsaKey.publicModLabel]!.isNotEmpty &&
          testMap[RsaKey.publicNLabel]!.isNotEmpty;
      expect(hasAllElements, isTrue);
    });
    test('convert map to model', () {
      RsaKey key = RsaKey(CryptionHelper.generateRsaKey());
      RsaKey key2 = RsaKey.fromMap(key.toStringMap);
      expect(key.rsaPrivateKey == key2.rsaPrivateKey, isTrue);
    });
  });
}
