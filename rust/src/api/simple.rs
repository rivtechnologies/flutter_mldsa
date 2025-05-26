use crate::api::mode::MldsaMode;
use ml_dsa::{
    signature::{Signer, Verifier},
    KeyGen, KeyPair, MlDsa44, MlDsa65, MlDsa87, MlDsaParams, Signature, SigningKey, VerifyingKey,
};
use rand::{CryptoRng, RngCore};

#[flutter_rust_bridge::frb(opaque)]
pub struct KeypairModel {
    mode: MldsaMode,
    public_key: Vec<u8>,
    private_key: Vec<u8>,
}
impl KeypairModel {
    #[flutter_rust_bridge::frb(sync)]
    pub fn public_key(&self) -> Vec<u8> {
        self.public_key.clone()
    }

    #[flutter_rust_bridge::frb(sync)]
    pub fn private_key(&self) -> Vec<u8> {
        self.private_key.clone()
    }

    #[flutter_rust_bridge::frb(sync)]
    pub fn mode(&self) -> MldsaMode {
        self.mode
    }

    fn generate_internal<
        Params: MlDsaParams,
        P: KeyGen<KeyPair = KeyPair<Params>>,
        R: RngCore + CryptoRng + ?Sized,
    >(
        mut rng: &mut R,
    ) -> (Vec<u8>, Vec<u8>) {
        let kp = P::key_gen(&mut rng);
        (
            kp.verifying_key().encode().to_vec(),
            kp.signing_key().encode().to_vec(),
        )
    }

    fn sign_message_internal<Params: MlDsaParams>(
        key_bytes: Vec<u8>,
        msg: Vec<u8>,
    ) -> anyhow::Result<Vec<u8>> {
        let key_array = hybrid_array::Array::try_from_iter(key_bytes.into_iter())?;

        let key = SigningKey::<Params>::decode(&key_array);

        let sig = key.try_sign(&msg).map_err(|err| anyhow::anyhow!(err))?;
        Ok(sig.encode().to_vec())
    }

    #[flutter_rust_bridge::frb(sync)]
    pub fn sign_message(
        mode: MldsaMode,
        key_bytes: Vec<u8>,
        msg: Vec<u8>,
    ) -> anyhow::Result<Vec<u8>> {
        match mode {
            MldsaMode::Mldsa44 => Self::sign_message_internal::<MlDsa44>(key_bytes, msg),
            MldsaMode::Mldsa65 => Self::sign_message_internal::<MlDsa65>(key_bytes, msg),
            MldsaMode::Mldsa87 => Self::sign_message_internal::<MlDsa87>(key_bytes, msg),
        }
    }

    fn verify_sig_internal<Params: MlDsaParams>(
        key_bytes: Vec<u8>,
        sig_bytes: Vec<u8>,
        msg: Vec<u8>,
    ) -> anyhow::Result<bool> {
        let key_array = hybrid_array::Array::try_from_iter(key_bytes.into_iter())?;

        let key = VerifyingKey::<Params>::decode(&key_array);

        let sig_array = hybrid_array::Array::try_from_iter(sig_bytes.into_iter())?;

        let sig = Signature::decode(&sig_array)
            .ok_or_else(|| anyhow::anyhow!("error decoding signature"))?;

        // let sig = key
        //     .try_sign(&msg)
        //     .map_err(|err| anyhow::anyhow!(err))?;
        Ok(key.verify(&msg, &sig).is_ok())
    }

    #[flutter_rust_bridge::frb(sync)]
    pub fn verify_sig(
        mode: MldsaMode,
        key_bytes: Vec<u8>,
        sig_bytes: Vec<u8>,
        msg: Vec<u8>,
    ) -> bool {
        match mode {
            MldsaMode::Mldsa44 => Self::verify_sig_internal::<MlDsa44>(key_bytes, sig_bytes, msg),
            MldsaMode::Mldsa65 => Self::verify_sig_internal::<MlDsa65>(key_bytes, sig_bytes, msg),
            MldsaMode::Mldsa87 => Self::verify_sig_internal::<MlDsa87>(key_bytes, sig_bytes, msg),
        }
        .unwrap_or(false)
    }

    #[flutter_rust_bridge::frb(sync)]
    pub fn generate(mode: MldsaMode) -> Self {
        let mut rng = rand::thread_rng();

        // let keys = MlDsa44::key_gen(&mut rng);
        let (public_key, private_key) = match mode {
            MldsaMode::Mldsa44 => Self::generate_internal::<MlDsa44, MlDsa44, _>(&mut rng),
            MldsaMode::Mldsa65 => Self::generate_internal::<MlDsa65, MlDsa65, _>(&mut rng),
            MldsaMode::Mldsa87 => Self::generate_internal::<MlDsa87, MlDsa87, _>(&mut rng),
        };
        KeypairModel::new(public_key, private_key, mode)
    }

    pub fn new(public_key: Vec<u8>, private_key: Vec<u8>, mode: MldsaMode) -> Self {
        let _public_key_size: usize = match mode {
            MldsaMode::Mldsa44 => 1312,
            MldsaMode::Mldsa65 => 1952,
            MldsaMode::Mldsa87 => 2592,
        };

        let _private_key_size: usize = match mode {
            MldsaMode::Mldsa44 => 2560,
            MldsaMode::Mldsa65 => 4032,
            MldsaMode::Mldsa87 => 4896,
        };

        assert_eq!(public_key.len(), _public_key_size);
        assert_eq!(private_key.len(), _private_key_size);
        KeypairModel {
            public_key: public_key,
            private_key: private_key,
            mode,
        }
    }
}
#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    // Default utilities - feel free to customize
    flutter_rust_bridge::setup_default_user_utils();
}

