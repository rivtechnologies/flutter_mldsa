import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:pointycastle/api.dart';

class MlDsaSignature extends Equatable implements Signature {
  final Uint8List sig;

  const MlDsaSignature({required this.sig});

  @override
  List<Object?> get props => [sig];
}
