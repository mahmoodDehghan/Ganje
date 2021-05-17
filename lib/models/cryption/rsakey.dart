import 'package:pointycastle/export.dart';

class RsaKey {
  static const privateExpLabel = 'pre';
  static const privateModLabel = 'prm';
  static const privatePLabel = 'prp';
  static const privateQLabel = 'prq';
  static const privateNLabel = 'prn';
  static const publicNLabel = 'pun';
  static const publicExpLabel = 'pue';
  static const publicModLabel = 'pum';
  final RSAPrivateKey rsaPrivateKey;
  final RSAPublicKey rsaPublicKey;

  RsaKey(AsymmetricKeyPair<PublicKey, PrivateKey> generatedKey)
      : rsaPrivateKey = generatedKey.privateKey as RSAPrivateKey,
        rsaPublicKey = generatedKey.publicKey as RSAPublicKey;

  RsaKey.fromMap(Map<String, dynamic> keyMap)
      : rsaPrivateKey = RSAPrivateKey(
            BigInt.parse(keyMap[privateModLabel]!),
            BigInt.parse(keyMap[privateExpLabel]!),
            BigInt.parse(keyMap[privatePLabel]!),
            BigInt.parse(keyMap[privateQLabel]!)),
        rsaPublicKey = RSAPublicKey(BigInt.parse(keyMap[publicModLabel]!),
            BigInt.parse(keyMap[publicExpLabel]!));

  Map<String, String> get toStringMap {
    var map = <String, String>{};
    map[publicModLabel] = rsaPublicKey.modulus.toString();
    map[publicExpLabel] = rsaPublicKey.exponent.toString();
    map[publicNLabel] = rsaPublicKey.n.toString();
    map[privateModLabel] = rsaPrivateKey.modulus.toString();
    map[privateExpLabel] = rsaPrivateKey.exponent.toString();
    map[privatePLabel] = rsaPrivateKey.p.toString();
    map[privateQLabel] = rsaPrivateKey.q.toString();
    map[privateNLabel] = rsaPrivateKey.n.toString();
    return map;
  }
}
