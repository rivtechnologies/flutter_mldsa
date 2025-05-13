import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_mldsa/flutter_mldsa.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pointycastle/api.dart';

class TestCase {
  final Uint8List message;
  final MlDsaSignature signature;
  final Uint8List publicKey;
  final Uint8List privateKey;
  final bool output;

  TestCase({
    required this.message,
    required this.signature,
    required this.publicKey,
    required this.privateKey,
    required this.output,
  });
}

void main() {
  test(
    'testing the signing process',
    () async {
      //******This is the intra MlDsa mode testing. Confirming correct behavior is enforced when dealing with two different modes is in another file***********
      await FlutterMldsa.init();

      final keyGenerator = MlDsaKeyGenerator();
      final generatorParams = MlDsaKeyGeneratorParams(mlDsaMode: MlDsaMode.MLDSA44);
      keyGenerator.init(generatorParams);

      final keypairA = keyGenerator.generateKeyPair();
      final keypairB = keyGenerator.generateKeyPair();

      final msgA = utf8.encode('YouWillNeverDecipherThis I hope');
      final msgB = utf8.encode('YouWillNeverDecipherThis I hoper');
      final msgC = utf8.encode('ThisIsAWayDifferentMsg');
      final msgD = utf8.encode('ThisoneIsJustToCompleteTheAlphabetTbh');

      final signerA = MlDsaSigner();
      final signerB = MlDsaSigner();
      signerA.init(true, PrivateKeyParameter<MlDsaPrivateKey>(keypairA.privateKey));
      signerB.init(true, PrivateKeyParameter<MlDsaPrivateKey>(keypairB.privateKey));

      final verifierA = MlDsaSigner();
      final verifierB = MlDsaSigner();

      verifierA.init(false, PublicKeyParameter<MlDsaPublicKey>(keypairA.publicKey));
      verifierB.init(false, PublicKeyParameter<MlDsaPublicKey>(keypairB.publicKey));

      //Time to wrap it up for the tests
      final signerList = [signerA, signerB];
      final msgList = [
        msgA,
        msgB,
        msgC,
        msgD,
      ];
      expect(
          listEquals([keypairA, keypairB].first.privateKey.keyBytes,
              signerList.first.privateKey?.keyBytes),
          true);

      for (final signer in signerList) {
        for (final message in msgList) {
          final verifierCorrect = MlDsaSigner();
          final verifierWrong = MlDsaSigner();

          if (listEquals(keypairA.privateKey.keyBytes, signer.privateKey!.keyBytes)) {
            verifierCorrect.init(false, PublicKeyParameter<MlDsaPublicKey>(keypairA.publicKey));
            verifierWrong.init(false, PublicKeyParameter<MlDsaPublicKey>(keypairB.publicKey));
          } else {
            verifierCorrect.init(false, PublicKeyParameter<MlDsaPublicKey>(keypairB.publicKey));
            verifierWrong.init(false, PublicKeyParameter<MlDsaPublicKey>(keypairA.publicKey));
          }

          final signature = signer.generateSignature(message);
          final successResult = verifierCorrect.verifySignature(message, signature);
          final failResult = verifierWrong.verifySignature(message, signature);
          expect(successResult, true);
          expect(failResult, false);
        }
      }
    },
  );
}
