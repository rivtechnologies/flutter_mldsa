// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:math';


import 'package:flutter_mldsa/flutter_mldsa.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pointycastle/api.dart';

typedef TestCase = MldsaMode;

void main() {
  group("signature verification tests", () {
    final List<TestCase> testcases = MldsaMode.values;
    for (final testcase in testcases) {
      test(testcase.name, () {
        //******This is the intra MlDsa mode testing. Confirming correct behavior is enforced when dealing with two different modes is in another file***********
        try {
          final keyGenerator = MlDsaKeyGenerator();
          final generatorParams = MlDsaKeyGeneratorParams(mlDsaMode: testcase);
          keyGenerator.init(generatorParams);

          final keypairs = List.generate(10, (_) => keyGenerator.generateKeyPair());

          final msgA = utf8.encode('YouWillNeverDecipherThis I hope');
          final msgB = utf8.encode('YouWillNeverDecipherThis I hoper');
          final msgC = utf8.encode('ThisIsAWayDifferentMsg');
          final msgD = utf8.encode('ThisoneIsJustToCompleteTheAlphabetTbh');

          final msgList = [msgA, msgB, msgC, msgD];
          final signers = keypairs
              .map(
                (kp) =>
                    MlDsaSigner()..init(true, PrivateKeyParameter<MlDsaPrivateKey>(kp.privateKey)),
              )
              .toList();

          final verifiers = keypairs
              .map(
                (kp) =>
                    MlDsaSigner()..init(false, PublicKeyParameter<MlDsaPublicKey>(kp.publicKey)),
              )
              .toList();

          for (var i = 0; i < keypairs.length; i++) {
            final verifierCorrect = verifiers[i];
            var wrongVerifierIdx = Random().nextInt(keypairs.length);
            while (wrongVerifierIdx == i) {
              wrongVerifierIdx = Random().nextInt(keypairs.length);
            }
            final verifierWrong = verifiers[wrongVerifierIdx];

            for (final message in msgList) {
              final signature = signers[i].generateSignature(message);
              final successResult = verifierCorrect.verifySignature(message, signature);
              final failResult = verifierWrong.verifySignature(message, signature);
              expect(successResult, true);
              expect(failResult, false);
            }
          }
        } catch (error, stacktrace) {
          print('****************');
          print('error: $error');
          print('stacktrace: $stacktrace');

          print('****************');
          fail(error.toString());
        }
      }, timeout: Timeout(Duration(days: 1)));
    }
    print('THE VERIFICATION TESTS');
  });
}
