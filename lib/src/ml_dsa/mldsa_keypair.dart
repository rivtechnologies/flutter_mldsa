import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import './ml_dsa_mode.dart';
import 'package:flutter_mldsa/src/rust/api/ml_dsa_44.dart';
import 'package:flutter_mldsa/src/rust/api/ml_dsa_65.dart';
import 'package:flutter_mldsa/src/rust/api/ml_dsa_87.dart';
import 'package:pointycastle/api.dart';

abstract interface class MlDsaAsymmetricKey implements AsymmetricKey {
  abstract final MlDsaMode mlDsaMode;
  abstract final Uint8List keyBytes;
}

sealed class MlDsaPrivateKey extends Equatable implements MlDsaAsymmetricKey, PrivateKey {
  const MlDsaPrivateKey();

  const factory MlDsaPrivateKey.mode44({required KeyPairMlDsa44 kp}) = MlDsaPrivateKey44;
  const factory MlDsaPrivateKey.mode65({required KeyPairMlDsa65 kp}) = MlDsaPrivateKey65;
  const factory MlDsaPrivateKey.mode87({required KeyPairMlDsa87 kp}) = MlDsaPrivateKey87;

  @override
  List<Object?> get props => [mlDsaMode, keyBytes];
}

class MlDsaPublicKey44 extends MlDsaPublicKey {
  final KeyPairMlDsa44 kp;

  @override
  Uint8List get keyBytes => fetchPublickey44(keys: kp);

  @override
  MlDsaMode get mlDsaMode => MlDsaMode.MLDSA44;

  const MlDsaPublicKey44({required this.kp});
}

class MlDsaPublicKey65 extends MlDsaPublicKey {
  final KeyPairMlDsa65 kp;

  @override
  Uint8List get keyBytes => fetchPublickey65(keys: kp);

  @override
  MlDsaMode get mlDsaMode => MlDsaMode.MLDSA65;

  const MlDsaPublicKey65({required this.kp});
}

class MlDsaPublicKey87 extends MlDsaPublicKey {
  final KeyPairMlDsa87 kp;

  @override
  Uint8List get keyBytes => fetchPublickey87(keys: kp);

  @override
  MlDsaMode get mlDsaMode => MlDsaMode.MLDSA87;

  const MlDsaPublicKey87({required this.kp});
}

class MlDsaPrivateKey44 extends MlDsaPrivateKey {
  final KeyPairMlDsa44 kp;

  @override
  Uint8List get keyBytes => fetchPrivatekey44(keys: kp);

  @override
  MlDsaMode get mlDsaMode => MlDsaMode.MLDSA44;

  const MlDsaPrivateKey44({required this.kp});
}

class MlDsaPrivateKey65 extends MlDsaPrivateKey {
  final KeyPairMlDsa65 kp;

  @override
  Uint8List get keyBytes => fetchPrivatekey65(keys: kp);

  @override
  MlDsaMode get mlDsaMode => MlDsaMode.MLDSA65;

  const MlDsaPrivateKey65({required this.kp});
}

class MlDsaPrivateKey87 extends MlDsaPrivateKey {
  final KeyPairMlDsa87 kp;

  @override
  Uint8List get keyBytes => fetchPrivatekey87(keys: kp);

  @override
  MlDsaMode get mlDsaMode => MlDsaMode.MLDSA44;

  const MlDsaPrivateKey87({required this.kp});
}

sealed class MlDsaPublicKey extends Equatable implements MlDsaAsymmetricKey, PublicKey {
  const MlDsaPublicKey();

  const factory MlDsaPublicKey.mode44({required KeyPairMlDsa44 kp}) = MlDsaPublicKey44;
  const factory MlDsaPublicKey.mode65({required KeyPairMlDsa65 kp}) = MlDsaPublicKey65;
  const factory MlDsaPublicKey.mode87({required KeyPairMlDsa87 kp}) = MlDsaPublicKey87;

  @override
  List<Object?> get props => [mlDsaMode, keyBytes];
}

class MlDsaKeyPair<Pub extends MlDsaPublicKey, Priv extends MlDsaPrivateKey>
    implements AsymmetricKeyPair<Pub, Priv> {
  MlDsaKeyPair({required this.privateKey, required this.publicKey})
      : assert(privateKey.mlDsaMode == publicKey.mlDsaMode, 'KeyPair must have the same mlDsaMode');

  @override
  final Priv privateKey;

  @override
  final Pub publicKey;
}
