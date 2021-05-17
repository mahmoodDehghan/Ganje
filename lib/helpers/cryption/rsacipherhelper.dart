import 'dart:typed_data';

import 'package:pointycastle/export.dart';

import '../../models/cryption/rsakey.dart';

class RsaCipherHelper {
  static const sha256AlgId = '0609608648016503040201';
  final RsaKey key;
  final Signer rsaSigner;
  final Signer rsaVerifier;
  RsaCipherHelper(this.key)
      : rsaSigner = Signer('SHA-256/RSA')
          ..init(true, PrivateKeyParameter<RSAPrivateKey>(key.rsaPrivateKey)),
        rsaVerifier = Signer('SHA-256/RSA')
          ..init(false, PublicKeyParameter<RSAPublicKey>(key.rsaPublicKey));

  RSASignature rsaSignature(Uint8List dataToSign,
      [String signerIdentifier = sha256AlgId]) {
    return rsaSigner.generateSignature(dataToSign) as RSASignature;
  }

  String rsaSign(String stringToSign) {
    return String.fromCharCodes(
        rsaSignature(new Uint8List.fromList(stringToSign.codeUnits)).bytes);
  }

  bool rsaVerify(String signString, String signature) {
    return rsaVerifyBytes(new Uint8List.fromList(signString.codeUnits),
        new Uint8List.fromList(signature.codeUnits));
  }

  bool rsaVerifyBytes(Uint8List signedData, Uint8List signature,
      [String verifierIdentifier = sha256AlgId]) {
    final sig = RSASignature(signature);

    try {
      return rsaVerifier.verifySignature(signedData, sig);
    } on ArgumentError {
      print('error');
      return false;
    }
  }

  Uint8List _processInBlocks(AsymmetricBlockCipher engine, Uint8List input) {
    final numBlocks = input.length ~/ engine.inputBlockSize +
        ((input.length % engine.inputBlockSize != 0) ? 1 : 0);

    final output = Uint8List(numBlocks * engine.outputBlockSize);

    var inputOffset = 0;
    var outputOffset = 0;
    while (inputOffset < input.length) {
      final chunkSize = (inputOffset + engine.inputBlockSize <= input.length)
          ? engine.inputBlockSize
          : input.length - inputOffset;

      outputOffset += engine.processBlock(
          input, inputOffset, chunkSize, output, outputOffset);

      inputOffset += chunkSize;
    }

    return (output.length == outputOffset)
        ? output
        : output.sublist(0, outputOffset);
  }

  String rsaEncrypt(String dataToEncrypt) {
    return String.fromCharCodes(
        rsaEncrypter(new Uint8List.fromList(dataToEncrypt.codeUnits)));
  }

  Uint8List rsaEncrypter(Uint8List dataToEncrypt) {
    final encrypter = OAEPEncoding(RSAEngine())
      ..init(true, PublicKeyParameter<RSAPublicKey>(key.rsaPublicKey));

    return _processInBlocks(encrypter, dataToEncrypt);
  }

  String rsaDecrypt(String cipherString) {
    return String.fromCharCodes(
        rsaDecrypter(new Uint8List.fromList(cipherString.codeUnits)));
  }

  Uint8List rsaDecrypter(Uint8List cipherText) {
    final decryptor = OAEPEncoding(RSAEngine())
      ..init(false, PrivateKeyParameter<RSAPrivateKey>(key.rsaPrivateKey));

    return _processInBlocks(decryptor, cipherText);
  }
}
