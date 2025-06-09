import 'package:flutter_mldsa/src/ml_dsa/mldsa_keypair.dart';
import 'package:flutter_mldsa/src/ml_dsa/mldsa_params.dart';
import 'package:flutter_mldsa/src/rust/api/mode.dart';
import 'package:pointycastle/api.dart';
// ignore: implementation_imports
import 'package:pointycastle/src/registry/registry.dart' as registry;


class MlDsaKeyGenerator implements KeyGenerator {
  static final registry.FactoryConfig factoryConfig =
      registry.StaticFactoryConfig(KeyGenerator, 'Mldsa', () => MlDsaKeyGenerator());
  late MldsaMode signingMode;

  MlDsaKeyGenerator({this.signingMode = MldsaMode.mldsa65});

  @override
  String get algorithmName => "Mldsa";

  @override
  MlDsaKeyPair generateKeyPair()  => MlDsaKeyPair.generate(mode: signingMode);

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
