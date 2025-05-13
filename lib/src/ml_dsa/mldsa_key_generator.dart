import 'package:flutter_mldsa/src/ml_dsa/mldsa_params.dart';
import 'package:flutter_mldsa/src/rust/api/ml_dsa_44.dart';
import 'package:flutter_mldsa/src/rust/api/ml_dsa_65.dart';
import 'package:flutter_mldsa/src/rust/api/ml_dsa_87.dart';
import 'package:pointycastle/api.dart';
import './ml_dsa_mode.dart';
import 'mldsa_keypair.dart';

class MlDsaKeyGenerator implements KeyGenerator {
  late MlDsaMode signingMode;

  MlDsaKeyGenerator({this.signingMode = MlDsaMode.MLDSA65});

  @override
  String get algorithmName => "MlDsa";

  @override
  MlDsaKeyPair generateKeyPair() {
    switch (signingMode) {
      case MlDsaMode.MLDSA44:
        final kp = generateKeys44();
        return MlDsaKeyPair(
            privateKey: MlDsaPrivateKey.mode44(kp: kp), publicKey: MlDsaPublicKey.mode44(kp: kp));
      case MlDsaMode.MLDSA65:
        final kp = generateKeys65();

        return MlDsaKeyPair(
            privateKey: MlDsaPrivateKey.mode65(kp: kp), publicKey: MlDsaPublicKey.mode65(kp: kp));

      case MlDsaMode.MLDSA87:
        final kp = generateKeys87();
        return MlDsaKeyPair(
            privateKey: MlDsaPrivateKey.mode87(kp: kp), publicKey: MlDsaPublicKey.mode87(kp: kp));
    }
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
