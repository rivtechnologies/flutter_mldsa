import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter_mldsa/src/rust/api/mode.dart';
import 'package:flutter_mldsa/src/rust/api/simple.dart';
import 'package:pointycastle/api.dart';

abstract interface class MlDsaAsymmetricKey implements AsymmetricKey {
  final MldsaMode mlDsaMode;
  final Uint8List keyBytes;

  MlDsaAsymmetricKey({required this.mlDsaMode, required this.keyBytes});
}

class MlDsaPrivateKey extends Equatable implements MlDsaAsymmetricKey, PrivateKey {
  @override
  final MldsaMode mlDsaMode;
  @override
  final Uint8List keyBytes;

  const MlDsaPrivateKey({required this.mlDsaMode, required this.keyBytes});

  factory MlDsaPrivateKey.fromKp({required KeypairModel kp}) =>
      MlDsaPrivateKey(mlDsaMode: kp.mode(), keyBytes: kp.privateKey());

  @override
  List<Object?> get props => [mlDsaMode, keyBytes];
}

class MlDsaPublicKey extends Equatable implements MlDsaAsymmetricKey, PublicKey {
  @override
  final MldsaMode mlDsaMode;
  @override
  final Uint8List keyBytes;

  const MlDsaPublicKey({required this.mlDsaMode, required this.keyBytes});

  factory MlDsaPublicKey.fromKp({required KeypairModel kp}) =>
      MlDsaPublicKey(mlDsaMode: kp.mode(), keyBytes: kp.publicKey());

  @override
  List<Object?> get props => [mlDsaMode, keyBytes];
}

class MlDsaKeyPair implements AsymmetricKeyPair<MlDsaPublicKey, MlDsaPrivateKey> {
  const MlDsaKeyPair({required this.kp});

  final KeypairModel kp;

  @override
  MlDsaPrivateKey get privateKey => MlDsaPrivateKey.fromKp(kp: kp);

  @override
  MlDsaPublicKey get publicKey => MlDsaPublicKey.fromKp(kp: kp);
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
