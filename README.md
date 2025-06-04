# Flutter MlDsa

[Pointycastle]() interface implentations for [MlDsa](https://csrc.nist.gov/pubs/fips/204/final) using bindings to [RustCrypto implementation of ml-dsa](https://docs.rs/ml-dsa/latest/ml_dsa/)

## ⚠️ Security Warning

The implementation contained in this crate has never been independently audited!

USE AT YOUR OWN RISK!

If you have discovered a security vulnerability in this project, please report it privately. Do not disclose it as a public issue. This gives us time to work with you to fix the issue before public exposure, reducing the chance that the exploit will be used before a patch is released. See SECURITY.md for more details.


## Getting started

Add `flutter_mldsa` and `pointycastle` to your dependencies

```bash
flutter pub add flutter_mldsa pointycastle
```

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
signer.init(true, PrivateKeyParameter<MlDsaPrivateKey>(keypairA.privateKey));
```

6. Create a verify and Initialize it:
```dart
final verifier = MlDsaSigner();
verifier.init(false, PublicKeyParameter<MlDsaPublicKey>(keypairA.publicKey));
```

7. Use the MlDsaSigner functions to sign and verify:
```dart
final signature = signer.generateSignature(message);
final result = verifier.verifySignature(message, signature);
```


8. (End of usage) Dispose the FlutterMldsa:
```dart
FlutterMldsa.dispose();
```


## Web Support via WASM

`flutter_mldsa` supports web by compiling the rust side to WASM, with some caveats.

### Steps
1. You will need the `flutter_rust_bridge_codegen` tool, install it with cargo:

```bash
cargo install flutter_rust_bridge_codegen
```

2. Navigate to your pub cache directory (usually `$HOME/.pub-cache`) and find flutter_mldsa, for example

```bash
cd $HOME/.pub-cache/hosted/pub.dev/flutter_mldsa-$VERSION/
```
where `$VERSION` is the version you are using 

3. Build the library for web (you will need the nightly rust compiler installed on your machine) 

```bash
flutter_rust_bridge_codegen build-web --release
```

4. Copy the built files in `web/pkg` to your app's `web/pkg` directory.

```bash
mkdir -p $PROJECT_ROOT/web/pkg
cp web/pkg/* $PROJECT_ROOT/web/pkg
```

where `$PROJECT_ROOT` is your app's root directory

5. Run your application with the --wasm flag

```bash
flutter run -d chrome --wasm
```

For an example build script, see the [`Makefile`](./example/Makefile) in the example 

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

### Flutter web

```bash
cd example
CHROMEDRIVER=path/to/chromedriver make test-web
```

## License
Licensed at:

 * [Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0)
 * [MIT license](http://opensource.org/licenses/MIT)
