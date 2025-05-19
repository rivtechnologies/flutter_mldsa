import 'package:flutter_mldsa/src/rust/api/mode.dart';
import 'package:pointycastle/api.dart';

class MlDsaKeyGeneratorParams extends CipherParameters {
  final MldsaMode mlDsaMode;

  MlDsaKeyGeneratorParams({required this.mlDsaMode});
}
