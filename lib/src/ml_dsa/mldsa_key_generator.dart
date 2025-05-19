import 'package:flutter_mldsa/src/ml_dsa/mldsa_keypair.dart';
import 'package:flutter_mldsa/src/ml_dsa/mldsa_params.dart';
import 'package:flutter_mldsa/src/rust/api/mode.dart';
import 'package:flutter_mldsa/src/rust/api/simple.dart';
import 'package:pointycastle/api.dart';

class MlDsaKeyGenerator implements KeyGenerator {
  late MldsaMode signingMode;

  MlDsaKeyGenerator({this.signingMode = MldsaMode.mldsa65});

  @override
  String get algorithmName => "MlDsa";

  @override
  MlDsaKeyPair generateKeyPair() {
    final kp = KeypairModel.generate(mode: signingMode);

    return MlDsaKeyPair(kp: kp);
  }

  @override
  void init(CipherParameters params) {
    switch (params) {
      case MlDsaKeyGeneratorParams(:final mlDsaMode):
        signingMode = mlDsaMode;

      default:
        throw Exception('Key Generator only takes MlDsaKeyGeneratorParams as an init parameter');
    }
  }
}

/// cipherParams seems to be the prepatory stages to when you will encrypt something. So it probably has to do with modes th pqc MlDsa dealt with.
/// This decides if the user Random or other types of signing, I think I will keep this one like this and keep init there for potential changes.
