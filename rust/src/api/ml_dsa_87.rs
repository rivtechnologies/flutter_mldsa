pub use ml_dsa::MlDsa87;

use hybrid_array::Array;
pub use ml_dsa::{
    signature::{Signer, Verifier},
    KeyGen, Signature,
};
pub use ml_dsa::{KeyPair, SigningKey, VerifyingKey};

#[flutter_rust_bridge::frb(sync)]
pub fn fetch_publickey_87(keys: &KeyPair<MlDsa87>) -> Vec<u8> {
    let result = keys.verifying_key().encode().to_vec();
    result
}

#[flutter_rust_bridge::frb(sync)]
pub fn fetch_privatekey_87(keys: &KeyPair<MlDsa87>) -> Vec<u8> {
    let result = keys.signing_key().encode().to_vec();
    result
}

#[flutter_rust_bridge::frb(sync)]
pub fn generate_keys_87() -> KeyPair<MlDsa87> {
    let mut rng = rand::thread_rng();
    let keys = MlDsa87::key_gen(&mut rng);
    keys
}
// &TryInto::<[_; <MlDsa87 as MlDsa87>::SigningKeySize]>::try_into(signing_key).into(),

#[flutter_rust_bridge::frb(sync)]
pub fn sign_message_87(key_bytes: Vec<u8>, msg: Vec<u8>) -> Vec<u8> {
    let Ok(key_array) = Array::try_from_iter(key_bytes.into_iter()) else {
        return [].to_vec();
    };
    let key = SigningKey::<MlDsa87>::decode(&key_array);

    let sig = key.sign(&msg);
    sig.encode().to_vec()
}

#[flutter_rust_bridge::frb(sync)]
pub fn verify_sig_87(key_bytes: Vec<u8>, sig_bytes: Vec<u8>, msg: Vec<u8>) -> bool {
    let Ok(key_array) = Array::try_from_iter(key_bytes.into_iter()) else {
        return false;
    };
    let key = VerifyingKey::<MlDsa87>::decode(&key_array);

    let Ok(sig_array) = Array::try_from_iter(sig_bytes.into_iter()) else {
        return false;
    };
    let Some(sig) = Signature::decode(&sig_array) else {
        return false;
    };

    key.verify(&msg, &sig).is_ok()
}
