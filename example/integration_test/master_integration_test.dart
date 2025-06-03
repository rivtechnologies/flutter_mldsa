import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter_mldsa/flutter_mldsa.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pointycastle/api.dart';

import 'keygen_test.dart' as keygen;
import 'signing_test.dart' as signing;
import 'verification_test.dart' as verification;

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(const Duration(days: 1));

  try {
    await FlutterMldsa.init();
    print('keygen tests incoming');
    await Future.delayed(Duration(seconds: 10));
    // keygen.main();
    print('signing tests incoming');
    await Future.delayed(Duration(seconds: 10));
    // signing.main();
    print('verification tests incoming');
    await Future.delayed(Duration(seconds: 10));
    // verification.main();
    // expect(false, true);
    // test('aaa', (){
    // expect(false, true);
    // });
    FlutterMldsa.dispose();
  } catch (e, st) {
    print(e);
    print(st);
  } finally {
    print('what da hellll');
  }
}
