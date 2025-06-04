import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_mldsa/src/rust/api/mode.dart';
import 'package:flutter_mldsa/src/rust/api/simple.dart';
import 'package:pointycastle/api.dart';

abstract interface class MlDsaAsymmetricKey implements AsymmetricKey {
  factory MlDsaAsymmetricKey.public({required MldsaMode mlDsaMode, required Uint8List keyBytes}) =
      MlDsaPublicKey;

  factory MlDsaAsymmetricKey.private({required MldsaMode mlDsaMode, required Uint8List keyBytes}) =
      MlDsaPrivateKey;
}

class MlDsaPrivateKey extends Equatable implements MlDsaAsymmetricKey, PrivateKey {
  MldsaMode get mlDsaMode => _key.mode();

  Uint8List signMsg(Uint8List msg) => _key.signMessage(msg: msg);

  Uint8List bytes() => _key.bytes();

  final SigningKeyOrRef _key;

  const MlDsaPrivateKey._(this._key);
  // : assert(!kIsWeb || mlDsaMode != MldsaMode.mldsa87, 'mldsa87 not supported on web');

  factory MlDsaPrivateKey({required MldsaMode mlDsaMode, required Uint8List keyBytes}) {
    final sk = SigningKey(mode: mlDsaMode, bytes: keyBytes);
    return MlDsaPrivateKey._(SigningKeyOrRef(key: sk));
  }

  @override
  List<Object?> get props => [_key];
}

class MlDsaPublicKey extends Equatable implements MlDsaAsymmetricKey, PublicKey {
  MldsaMode get mlDsaMode => _key.mode();

  final VerifyingKeyOrRef _key;

  bool verifySig(Uint8List sigBytes, Uint8List msg) => _key.verifySig(sigBytes: sigBytes, msg: msg);

  Uint8List bytes() => _key.bytes();

  const MlDsaPublicKey._(this._key);
  // : assert(!kIsWeb || mlDsaMode != MldsaMode.mldsa87, 'mldsa87 not supported on web');

  factory MlDsaPublicKey({required MldsaMode mlDsaMode, required Uint8List keyBytes}) {
    final vk = VerifyingKey(mode: mlDsaMode, bytes: keyBytes);
    return MlDsaPublicKey._(VerifyingKeyOrRef(key: vk));
  }

  @override
  List<Object?> get props => [_key];
}

class MlDsaKeyPair implements AsymmetricKeyPair<MlDsaPublicKey, MlDsaPrivateKey> {
  // MlDsaKeyPair(
  //     {required MlDsaPublicKey})
  //     : kp = KeyPair(publicKey: publicKey, privateKey: privateKey, mode: mode),
  //       assert(!kIsWeb || mode != MldsaMode.mldsa87, 'mldsa87 not supported on web');

  const MlDsaKeyPair._(this._kp);

  factory MlDsaKeyPair(
          {required MldsaMode mode, required Uint8List pubKey, required Uint8List privKey}) =>
      MlDsaKeyPair._(KeyPair(
          verifyingKey: VerifyingKey(mode: mode, bytes: pubKey),
          signingKey: SigningKey(mode: mode, bytes: privKey)));

  final KeyPair _kp;

  factory MlDsaKeyPair.generate({required MldsaMode mode}) =>
      MlDsaKeyPair._(KeyPair.generate(mode: mode));

  @override
  MlDsaPrivateKey get privateKey => MlDsaPrivateKey._(_kp.signingKey());

  @override
  MlDsaPublicKey get publicKey => MlDsaPublicKey._(_kp.verifyingKey());
}

// class MlDsaPublicKey44 extends MlDsaPublicKey {
//   final KeyPairMlDsa44 kp;

//   @override
//   Uint8List get keyBytes => fetchPublickey44(keys: kp);

//   @override
//   MlDsaMode get mlDsaMode => MlDsaMode.MLDSA44;

//   const MlDsaPublicKey44({required this.kp});
// }

// class MlDsaPublicKey65 extends MlDsaPublicKey {
//   final KeyPairMlDsa65 kp;

//   @override
//   Uint8List get keyBytes => fetchPublickey65(keys: kp);

//   @override
//   MlDsaMode get mlDsaMode => MlDsaMode.MLDSA65;

//   const MlDsaPublicKey65({required this.kp});
// }

// class MlDsaPublicKey87 extends MlDsaPublicKey {
//   final KeyPairMlDsa87 kp;

//   @override
//   Uint8List get keyBytes => fetchPublickey87(keys: kp);

//   @override
//   MlDsaMode get mlDsaMode => MlDsaMode.MLDSA87;

//   const MlDsaPublicKey87({required this.kp});
// }

// class MlDsaPrivateKey44 extends MlDsaPrivateKey {
//   final KeyPairMlDsa44 kp;

//   @override
//   Uint8List get keyBytes => fetchPrivatekey44(keys: kp);

//   @override
//   MlDsaMode get mlDsaMode => MlDsaMode.MLDSA44;

//   const MlDsaPrivateKey44({required this.kp});
// }

// class MlDsaPrivateKey65 extends MlDsaPrivateKey {
//   final KeyPairMlDsa65 kp;

//   @override
//   Uint8List get keyBytes => fetchPrivatekey65(keys: kp);

//   @override
//   MlDsaMode get mlDsaMode => MlDsaMode.MLDSA65;

//   const MlDsaPrivateKey65({required this.kp});
// }

// class MlDsaPrivateKey87 extends MlDsaPrivateKey {
//   final KeyPairMlDsa87 kp;

//   @override
//   Uint8List get keyBytes => fetchPrivatekey87(keys: kp);

//   @override
//   MlDsaMode get mlDsaMode => MlDsaMode.MLDSA44;

//   const MlDsaPrivateKey87({required this.kp});
// }
