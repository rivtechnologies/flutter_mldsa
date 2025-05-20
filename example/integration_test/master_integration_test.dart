import 'package:flutter_mldsa/flutter_mldsa.dart';
import 'package:flutter_test/flutter_test.dart';

import 'keygen_test.dart' as keygen;
import 'signing_test.dart' as signing;
import 'verification_test.dart' as verification;

void main() {
  setUpAll(FlutterMldsa.init);
  tearDownAll(FlutterMldsa.dispose);

  keygen.main();
  signing.main();
  verification.main();
}
