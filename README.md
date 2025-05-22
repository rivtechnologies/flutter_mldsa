# Flutter MlDsa

[Pointycastle]() interface implentations for [MlDsa](https://csrc.nist.gov/pubs/fips/204/final) using bindings to [RustCrypto implementation of ml-dsa](https://docs.rs/ml-dsa/latest/ml_dsa/)

## ⚠️ Security Warning

The implementation contained in this crate has never been independently audited!

USE AT YOUR OWN RISK!

If you have discovered a security vulnerability in this project, please report it privately. Do not disclose it as a public issue. This gives us time to work with you to fix the issue before public exposure, reducing the chance that the exploit will be used before a patch is released. See SECURITY.md for more details.

# PQC-MlDsa


## Getting started

To generate the needed files for the bridge:
```
flutter_rust_bridge_codegen generate --watch --stop-on-error
```


## Testing

### Rust-Side

```bash
cd rust
cargo test -- --show-output
```


### Flutter-Side

```bash
cd example
flutter test -d $DEVICE integration_test/master_integration_test.dart
```

where `$DEVICE` is set to a device on the platform you want to test (for example `linux`, `emulator-5554`)

## Usage

1. Initialize the FlutterMldsa:

```dart
await FlutterMldsa.init();
```


2. Create a MlDsaKeyGenerator:

```dart
final keyGenerator = MlDsaKeyGenerator();
```

OR

```dart
final keyGenerator = KeyGenerator('Mldsa'); //Case sensitive
```

3. Initialize the generator with a mode to generate
```dart
final generatorParams = MlDsaKeyGeneratorParams(mlDsaMode: MlDsaMode.MLDSA44);
keyGenerator.init(generatorParams);
```

4. Generate a keypair:
```dart
final keypairA = keyGenerator.generateKeyPair();
```

5. Create a Signer and initialize it:
```dart
final signer = MlDsaSigner();
signer.init(true, PrivateKeyParameter<MlDsaPrivateKey>(keypairA.privateKeyBytes));
```

6. Create a verify and Initialize it:
```dart
final verifier = MlDsaSigner();
verifier.init(false, PublicKeyParameter<MlDsaPublicKey>(keypairA.publicKeyBytes));
```

7. Use the MlDsaSigner functions to sign and verify:
```dart
final signature = signer.generateSignature(message);
final result = verifierCorrect.verifySignature(message, signature);
```


8. (End of usage) Dispose the FlutterMldsa:
```dart
FlutterMldsa.dispose();
```

## License
Licensed at:

 * [Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0)
 * [MIT license](http://opensource.org/licenses/MIT)
