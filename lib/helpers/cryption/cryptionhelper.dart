import 'dart:math';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';

class CryptionHelper {
  static SecureRandom createRandomSecure() {
    final secureRandom = FortunaRandom();
    var seedSource = Random.secure();
    var values = <int>[];
    for (int i = 0; i < 32; i++) {
      values.add(seedSource.nextInt(255));
    }
    secureRandom.seed(KeyParameter(Uint8List.fromList(values)));
    return secureRandom;
  }

  static AsymmetricKeyPair<PublicKey, PrivateKey> generateRsaKey() {
    SecureRandom mySecureRandom = CryptionHelper.createRandomSecure();
    final rsaKeyGen = KeyGenerator('RSA')
      ..init(ParametersWithRandom(
          RSAKeyGeneratorParameters(BigInt.parse('66539'), 2048, 64),
          mySecureRandom));

    return rsaKeyGen.generateKeyPair();
  }
}
