use std::ops::Deref;

use crate::api::mode::MldsaMode;
use ml_dsa::{
    signature::{Signer, Verifier},
    KeyGen, KeyPair as KeyPairImpl, MlDsa44, MlDsa65, MlDsa87, Signature,
    SigningKey as SigningKeyImpl, VerifyingKey as VerifyingKeyImpl,
};

#[flutter_rust_bridge::frb(opaque)]
pub enum VerifyingKeyOrRef<'a> {
    VerifyingKey(VerifyingKey),
    VerifyingKeyRef(&'a VerifyingKey),
}

impl<'a> Deref for VerifyingKeyOrRef<'a> {
    type Target = VerifyingKey;

    fn deref(&self) -> &Self::Target {
        match self {
            VerifyingKeyOrRef::VerifyingKey(vk) => vk,
            VerifyingKeyOrRef::VerifyingKeyRef(vk) => vk,
        }
    }
}

impl<'a> VerifyingKeyOrRef<'a> {
    #[flutter_rust_bridge::frb(sync)]
    pub fn new(key: VerifyingKey) -> VerifyingKeyOrRef<'a> {
        VerifyingKeyOrRef::VerifyingKey(key)
    }

    #[flutter_rust_bridge::frb(sync)]
    pub fn mode(&self) -> MldsaMode {
        self.deref().mode()
    }

    #[flutter_rust_bridge::frb(sync)]
    pub fn verify_sig(&self, sig_bytes: &Vec<u8>, msg: &Vec<u8>) -> bool {
        self.deref().verify_sig(sig_bytes, msg)
    }

    #[flutter_rust_bridge::frb(sync)]
    pub fn bytes(&self) -> Vec<u8> {
        self.deref().bytes()
    }
}

#[flutter_rust_bridge::frb(opaque)]
pub enum VerifyingKey {
    VerifyingKey44(Box<VerifyingKeyImpl<MlDsa44>>),
    VerifyingKey65(Box<VerifyingKeyImpl<MlDsa65>>),
    VerifyingKey87(Box<VerifyingKeyImpl<MlDsa87>>),
}

impl VerifyingKey {
    #[flutter_rust_bridge::frb(sync)]
    pub fn new(mode: MldsaMode, bytes: &Vec<u8>) -> anyhow::Result<Self> {
        match mode {
            MldsaMode::Mldsa44 => Ok(VerifyingKey::VerifyingKey44(Box::new(
                VerifyingKeyImpl::decode(&hybrid_array::Array::try_from_iter(
                    bytes.to_owned().into_iter(),
                )?),
            ))),
            MldsaMode::Mldsa65 => Ok(VerifyingKey::VerifyingKey65(Box::new(
                VerifyingKeyImpl::decode(&hybrid_array::Array::try_from_iter(
                    bytes.to_owned().into_iter(),
                )?),
            ))),
            MldsaMode::Mldsa87 => Ok(VerifyingKey::VerifyingKey87(Box::new(
                VerifyingKeyImpl::decode(&hybrid_array::Array::try_from_iter(
                    bytes.to_owned().into_iter(),
                )?),
            ))),
        }
    }

    #[flutter_rust_bridge::frb(sync)]
    pub fn mode(&self) -> MldsaMode {
        match self {
            VerifyingKey::VerifyingKey44(_) => MldsaMode::Mldsa44,
            VerifyingKey::VerifyingKey65(_) => MldsaMode::Mldsa65,
            VerifyingKey::VerifyingKey87(_) => MldsaMode::Mldsa87,
        }
    }

    #[flutter_rust_bridge::frb(sync)]
    pub fn verify_sig(&self, sig_bytes: &Vec<u8>, msg: &Vec<u8>) -> bool {
        match self {
            VerifyingKey::VerifyingKey44(vk) => {
                hybrid_array::Array::try_from_iter(sig_bytes.to_owned().into_iter())
                    .ok()
                    .and_then(|sig| Signature::decode(&sig))
                    .and_then(|sig| vk.verify(msg, &sig).ok())
                    .is_some()
            }
            VerifyingKey::VerifyingKey65(vk) => {
                hybrid_array::Array::try_from_iter(sig_bytes.to_owned().into_iter())
                    .ok()
                    .and_then(|sig| Signature::decode(&sig))
                    .and_then(|sig| vk.verify(msg, &sig).ok())
                    .is_some()
            }
            VerifyingKey::VerifyingKey87(vk) => {
                hybrid_array::Array::try_from_iter(sig_bytes.to_owned().into_iter())
                .ok()
                .and_then(|sig| Signature::decode(&sig))
                .and_then(|sig| vk.verify(msg, &sig).ok())
                .is_some()
            }
        }
    }

    #[flutter_rust_bridge::frb(sync)]
    pub fn bytes(&self) -> Vec<u8> {
        match self {
            VerifyingKey::VerifyingKey44(vk) => vk.encode().to_vec(),
            VerifyingKey::VerifyingKey65(vk) => vk.encode().to_vec(),
            VerifyingKey::VerifyingKey87(vk) => vk.encode().to_vec(),
        }
    }
}

#[flutter_rust_bridge::frb(opaque)]
pub enum SigningKeyOrRef<'a> {
    SigningKey(SigningKey),
    SigningKeyRef(&'a SigningKey),
}

impl<'a> Deref for SigningKeyOrRef<'a> {
    type Target = SigningKey;

    fn deref(&self) -> &Self::Target {
        match self {
            SigningKeyOrRef::SigningKey(vk) => &vk,
            SigningKeyOrRef::SigningKeyRef(vk) => vk,
        }
    }
}

impl<'a> SigningKeyOrRef<'a> {
    #[flutter_rust_bridge::frb(sync)]
    pub fn new(key: SigningKey) -> SigningKeyOrRef<'a> {
        SigningKeyOrRef::SigningKey(key)
    }

    #[flutter_rust_bridge::frb(sync)]
    pub fn mode(&self) -> MldsaMode {
        self.deref().mode()
    }

    #[flutter_rust_bridge::frb(sync)]
    pub fn sign_message(&self, msg: &Vec<u8>) -> Vec<u8> {
        self.deref().sign_message(msg)
    }

    #[flutter_rust_bridge::frb(sync)]
    pub fn bytes(&self) -> Vec<u8> {
        self.deref().bytes()
    }
}

#[flutter_rust_bridge::frb(opaque)]
pub enum SigningKey {
    SigningKey44(Box<SigningKeyImpl<MlDsa44>>),
    SigningKey65(Box<SigningKeyImpl<MlDsa65>>),
    SigningKey87(Box<SigningKeyImpl<MlDsa87>>),
}

impl SigningKey {
    #[flutter_rust_bridge::frb(sync)]
    pub fn new(mode: MldsaMode, bytes: &Vec<u8>) -> anyhow::Result<Self> {
        match mode {
            MldsaMode::Mldsa44 => Ok(SigningKey::SigningKey44(Box::new(SigningKeyImpl::decode(
                &hybrid_array::Array::try_from_iter(bytes.to_owned().into_iter())?,
            )))),
            MldsaMode::Mldsa65 => Ok(SigningKey::SigningKey65(Box::new(SigningKeyImpl::decode(
                &hybrid_array::Array::try_from_iter(bytes.to_owned().into_iter())?,
            )))),
            MldsaMode::Mldsa87 => Ok(SigningKey::SigningKey65(Box::new(SigningKeyImpl::decode(
                &hybrid_array::Array::try_from_iter(bytes.to_owned().into_iter())?,
            )))),
        }
    }

    #[flutter_rust_bridge::frb(sync)]
    pub fn mode(&self) -> MldsaMode {
        match self {
            SigningKey::SigningKey44(_) => MldsaMode::Mldsa44,
            SigningKey::SigningKey65(_) => MldsaMode::Mldsa65,
            SigningKey::SigningKey87(_) => MldsaMode::Mldsa87,
        }
    }

    #[flutter_rust_bridge::frb(sync)]
    pub fn sign_message(&self, msg: &Vec<u8>) -> Vec<u8> {
        match self {
            SigningKey::SigningKey44(sk) => sk.sign(&msg).encode().to_vec(),
            SigningKey::SigningKey65(sk) => sk.sign(&msg).encode().to_vec(),
            SigningKey::SigningKey87(sk) => sk.sign(&msg).encode().to_vec()
        }
    }

    #[flutter_rust_bridge::frb(sync)]
    pub fn bytes(&self) -> Vec<u8> {
        match self {
            SigningKey::SigningKey44(sk) => sk.encode().to_vec(),
            SigningKey::SigningKey65(sk) => sk.encode().to_vec(),
            SigningKey::SigningKey87(sk) => sk.encode().to_vec(),
        }
    }
}

#[flutter_rust_bridge::frb(opaque)]
pub struct KeyPair {
    verifying_key: VerifyingKey,
    signing_key: SigningKey,
}

impl KeyPair {
    #[flutter_rust_bridge::frb(sync)]
    pub fn signing_key<'a>(&'a self) -> SigningKeyOrRef<'a> {
        SigningKeyOrRef::SigningKeyRef(&self.signing_key)
    }

    #[flutter_rust_bridge::frb(sync)]
    pub fn verifying_key<'a>(&'a self) -> VerifyingKeyOrRef<'a> {
        VerifyingKeyOrRef::VerifyingKeyRef(&self.verifying_key)
    }

    #[flutter_rust_bridge::frb(sync)]
    pub fn new(verifying_key: VerifyingKey, signing_key: SigningKey) -> anyhow::Result<KeyPair> {
        if verifying_key.mode() != signing_key.mode() {
            Err(anyhow::anyhow!(
                "verifying key and signing key mode must match"
            ))
        } else {
            Ok(Self {
                verifying_key,
                signing_key,
            })
        }
    }

    #[flutter_rust_bridge::frb(sync)]
    pub fn mode(&self) -> MldsaMode {
        self.signing_key().mode()
    }

    #[flutter_rust_bridge::frb(sync)]
    pub fn generate(mode: MldsaMode) -> KeyPair {
        let mut rng = rand::thread_rng();
        /// match the mode
        match mode {
            MldsaMode::Mldsa44 => {
                let kp = MlDsa44::key_gen(&mut rng);
                kp.into()
            }
            MldsaMode::Mldsa65 => {
                let kp = MlDsa65::key_gen(&mut rng);
                kp.into()
            }
            MldsaMode::Mldsa87 => {
                let kp = MlDsa87::key_gen(&mut rng);
                kp.into()
            }
        }
    }
}

impl From<KeyPairImpl<MlDsa44>> for KeyPair {
    fn from(value: KeyPairImpl<MlDsa44>) -> Self {
        let signing_key = SigningKey::SigningKey44(Box::new(value.signing_key().to_owned()));
        let verifying_key =
            VerifyingKey::VerifyingKey44(Box::new(value.verifying_key().to_owned()));
        Self {
            verifying_key,
            signing_key,
        }
    }
}

impl From<KeyPairImpl<MlDsa65>> for KeyPair {
    fn from(value: KeyPairImpl<MlDsa65>) -> Self {
        let signing_key = SigningKey::SigningKey65(Box::new(value.signing_key().to_owned()));
        let verifying_key =
            VerifyingKey::VerifyingKey65(Box::new(value.verifying_key().to_owned()));
        Self {
            verifying_key,
            signing_key,
        }
    }
}

impl From<KeyPairImpl<MlDsa87>> for KeyPair {
    fn from(value: KeyPairImpl<MlDsa87>) -> Self {
        let signing_key = SigningKey::SigningKey87(Box::new(value.signing_key().to_owned()));
        let verifying_key =
            VerifyingKey::VerifyingKey87(Box::new(value.verifying_key().to_owned()));
        Self {
            verifying_key,
            signing_key,
        }
    }
}

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    // Default utilities - feel free to customize
    flutter_rust_bridge::setup_default_user_utils();
}
