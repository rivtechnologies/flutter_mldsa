// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:math';

import 'package:flutter_mldsa/flutter_mldsa.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pointycastle/api.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Mldsa WASM', (WidgetTester tester) async {
    await FlutterMldsa.init();
    final modeList = MldsaMode.values;
    _testMldsa(modeList);
    FlutterMldsa.dispose();
  });
}

Future<void> _testMldsa(List<MldsaMode> testcases) async {
  for (final testcase in testcases) {
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
            (kp) => MlDsaSigner()..init(true, PrivateKeyParameter<MlDsaPrivateKey>(kp.privateKey)),
          )
          .toList();

      final verifiers = keypairs
          .map(
            (kp) => MlDsaSigner()..init(false, PublicKeyParameter<MlDsaPublicKey>(kp.publicKey)),
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
          print('it tested');
          if (successResult == true && failResult == false) {
            print('passed');
          }
        }
      }
    } catch (error, stacktrace) {
      print('****************');
      print('error: $error');
      print('stacktrace: $stacktrace');

      print('****************');
      fail(error.toString());
    }
    return;
  }
}
