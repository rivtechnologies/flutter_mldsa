import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_mldsa/src/ml_dsa/mldsa_exceptions.dart';
import 'package:flutter_mldsa/src/ml_dsa/mldsa_keypair.dart';
import 'package:flutter_mldsa/src/ml_dsa/mldsa_signature.dart';
import 'package:pointycastle/api.dart';

class MlDsaSigner implements Signer {
  MlDsaPublicKey? _public;
  MlDsaPrivateKey? _private;
  bool? _forSigning;

  MlDsaSigner();

  MlDsaPublicKey? get publicKey => _public;
  MlDsaPrivateKey? get privateKey => _private;

  @override
  String get algorithmName => "MlDsa";

  //we need the bridged generate Signature hre.

  @override
  void init(bool forSigning, CipherParameters params) {
    // reset();
    _forSigning = forSigning;
    //We assume if the for signing is null, it is for signing

    if (forSigning == false) {
      if (params is PublicKeyParameter<MlDsaPublicKey>) {
        _public = params.key;
      }
    } else if (params is PrivateKeyParameter<MlDsaPrivateKey>) {
      _private = params.key;
    } else {}

    // maybe do nothing? maybe initialize private and public key?
  }

  @override
  void reset() {
    // Usually will do nothing. Here we reset the digest or similar algorithms, plot twist, they did nothing
    _public = null;
    _private = null;
    _forSigning = null;
  }

  @override
  MlDsaSignature generateSignature(Uint8List message) {
    if (_forSigning == null || _private == null) {
      throw (Exception('Sign Msg (No Configuration), Use Init Method'));
    } else if (_forSigning != true) {
      throw (Exception('Sign Msg (Verifier Configuration), Use Init Method'));
    }


    return MlDsaSignature(
        sig: _private!.signMsg(message));
  }

  @override
  bool verifySignature(Uint8List message, covariant MlDsaSignature signature) {
    if (_forSigning == null) {
      throw (Exception('Verify Signature (No Configuration), Use Init() Method'));
    }
    if (_forSigning == true || _public == null ) {
      throw (Exception('The user tried to verify with the signing configuration'));
    }
    try {
      return _public!.verifySig(signature.sig, message);
    } catch (e, stackTrace) {
      debugPrint('error: Error in Verifying Signature: $e, stackTrace: $stackTrace');

      throw MlDsaSigningException(
          error: 'Error in Verifying Signature: $e', stackTrace: stackTrace);
    }
  }
}
