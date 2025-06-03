import 'dart:convert';
import 'package:flutter_mldsa/src/ml_dsa/mldsa_key_generator.dart';
import 'package:flutter_mldsa/src/ml_dsa/mldsa_params.dart';
import 'package:flutter_mldsa/src/ml_dsa/mldsa_keypair.dart';
import 'package:flutter_mldsa/src/ml_dsa/mldsa_signer.dart';
import 'package:flutter_mldsa/src/rust/api/mode.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:pointycastle/api.dart';


typedef TestCase = MldsaMode;

void main() {
  group("signature generation tests", () {
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

          for (final signer in signers) {
            for (final message in msgList) {
              signer.generateSignature(message);
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
    print('THE SIGNING TESTS');
  });
}
