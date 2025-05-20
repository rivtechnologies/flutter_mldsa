# Flutter PQC MlDsa

Bindings to [RustCrypto implementation of ml-dsa](https://docs.rs/ml-dsa/latest/ml_dsa/)


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

1. Create a MlDsaKeyGenerator:

```dart
final keyGenerator = MlDsaKeyGenerator();
```

OR

```dart
final keyGenerator = KeyGenerator('Mldsa'); //Case sensitive
```

2. Initialize the generator with a mode to generate
```dart
final generatorParams = MlDsaKeyGeneratorParams(mlDsaMode: MlDsaMode.MLDSA44);
keyGenerator.init(generatorParams);
```

3. Generate a keypair:
```dart
final keypairA = keyGenerator.generateKeyPair();
```

4. Create a Signer and initialize it:
```dart
final signer = MlDsaSigner();
signer.init(true, PrivateKeyParameter<MlDsaPrivateKey>(keypairA.privateKeyBytes));
```

5. Create a verify and Initialize it:
```dart
final verifier = MlDsaSigner();
verifier.init(false, PublicKeyParameter<MlDsaPublicKey>(keypairA.publicKeyBytes));
```

6. Use the MlDsaSigner functions to sign and verify:
```dart
final signature = signer.generateSignature(message);
final result = verifierCorrect.verifySignature(message, signature);
```
