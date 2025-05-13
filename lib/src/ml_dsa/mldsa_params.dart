import 'ml_dsa_mode.dart';
import 'package:pointycastle/api.dart';

class MlDsaKeyGeneratorParams extends CipherParameters {
  final MlDsaMode mlDsaMode;

  MlDsaKeyGeneratorParams({required this.mlDsaMode});
}
