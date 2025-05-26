library;

import 'package:flutter_mldsa/src/ml_dsa/mldsa_key_generator.dart';
import 'package:flutter_mldsa/src/rust/frb_generated.dart';

export 'package:flutter_mldsa/src/ml_dsa/mldsa_exceptions.dart';
export 'package:flutter_mldsa/src/ml_dsa/mldsa_key_generator.dart';
export 'package:flutter_mldsa/src/ml_dsa/mldsa_params.dart';
export 'package:flutter_mldsa/src/ml_dsa/mldsa_keypair.dart';
export 'package:flutter_mldsa/src/ml_dsa/mldsa_signature.dart';
export 'package:flutter_mldsa/src/ml_dsa/mldsa_signer.dart';
export 'package:flutter_mldsa/src/rust/api/mode.dart';
// ignore: implementation_imports
import 'package:pointycastle/src/registry/registry.dart' show registry;

class FlutterMldsa {
  FlutterMldsa._();
  static bool _isInit = false;
  static bool _registryIsInit = false;
  static Future<void> init() async {
    if (!_isInit) {
      await RustLib.init();
      if (!_registryIsInit) {
        _registerMlDsaKeyGenerator();
        _registryIsInit = true;
      }
      _isInit = true;
    }
  }

  static void dispose() {
    if (_isInit) {
      RustLib.dispose();
      _isInit = false;
    }
  }

  static void _registerMlDsaKeyGenerator() {
    registry.register<MlDsaKeyGenerator>(MlDsaKeyGenerator.factoryConfig);
  }
}
