
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
          final keyGenerator = KeyGenerator('Mldsa');
          final generatorParams = MlDsaKeyGeneratorParams(mlDsaMode: testcase);
          keyGenerator.init(generatorParams);

          for (var i = 0; i < 10; i++) {
            keyGenerator.generateKeyPair();
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
  });
}
