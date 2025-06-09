// ignore_for_file: avoid_print

import 'package:flutter_mldsa/flutter_mldsa.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'keygen_test.dart' as keygen;
import 'signing_test.dart' as signing;
import 'verification_test.dart' as verification;

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  try {
    await FlutterMldsa.init();
    print('keygen tests incoming');
    keygen.main();
    print('signing tests incoming');
    signing.main();
    print('verification tests incoming');
    verification.main();

    FlutterMldsa.dispose();
  } catch (e, st) {
    print(e);
    print(st);
    fail(e.toString());
  }
}
