# Flutter PQC MlDsa

Bindings to [RustCrypto implementation of ml-dsa](https://docs.rs/ml-dsa/latest/ml_dsa/)


# PQC-MlDsa


## Getting started

make sure to run
```
flutter_rust_bridge_codegen generate --watch --stop-on-error
```

If you want to use the test project, use the test in the example folder.


## Usage

<br>
1-Create a MlDsaKeyGenerator:
```
final keyGenerator = MlDsaKeyGenerator();
```

2-Init the generator with a maode to generate
```
final generatorParams = MlDsaKeyGeneratorParams(mlDsaMode: MlDsaMode.MLDSA44);
keyGenerator.init(generatorParams);
```

3-Generate a keypair:
```
final keypairA = keyGenerator.generateKeyPair();
```

4-Create a Signer and init it:
```
final signer = MlDsaSigner();
signer.init(true, PrivateKeyParameter<MlDsaPrivateKey>(keypairA.privateKey));
```

5-Create a verify and init it:
```
final verifier = MlDsaSigner();
verifier.init(false, PublicKeyParameter<MlDsaPublicKey>(keypairA.publicKey));
```

6-Use the MlDsaSigner functions to sign and verify:
```
final signature = signer.generateSignature(message);
final result = verifierCorrect.verifySignature(message, signature);
```
