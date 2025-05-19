library;

import 'package:flutter_mldsa/src/rust/frb_generated.dart';

export 'package:flutter_mldsa/src/ml_dsa/mldsa_exceptions.dart';
export 'package:flutter_mldsa/src/ml_dsa/mldsa_key_generator.dart';
export 'package:flutter_mldsa/src/ml_dsa/mldsa_params.dart';
export 'package:flutter_mldsa/src/ml_dsa/mldsa_keypair.dart';
export 'package:flutter_mldsa/src/ml_dsa/mldsa_signature.dart';
export 'package:flutter_mldsa/src/ml_dsa/mldsa_signer.dart';
export 'package:flutter_mldsa/src/rust/api/mode.dart';
class FlutterMldsa {
  static Future<void> init() => RustLib.init();
  static void dispose() => RustLib.dispose();
}
