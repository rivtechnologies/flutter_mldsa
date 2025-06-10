use crate::api::{mode::MldsaMode};
use crate::api::simple::KeyPair;

#[test]
fn mldsa_all_modes_work() {
    let msg = b"Thios is a totally randam santences withLats oF TpYo".to_vec();

    let mode_list = [MldsaMode::Mldsa44, MldsaMode::Mldsa65, MldsaMode::Mldsa87];
    for mode in mode_list {
        println!("\n\n ###################-Mldsa Mode: {:?}-###################", mode);
        println!("The message is :\n{:?}", msg.to_vec());
        let keys = KeyPair::generate(mode);
        print!("\nKeypair public/private key conform to the expected size");
        let public_key = keys.verifying_key();
        let private_key = keys.signing_key();

        let public_key_length = public_key.bytes().len();
        let private_key_length =  private_key.bytes().len();

        let sig_bytes = private_key.sign_message(&msg);
        print!("\nThe signature is generated correctly");
        let result = public_key.verify_sig(&sig_bytes, &msg);
        assert_eq!(result, true);

        println!("\nThe result of verification is: {:?}", result);
        print!("\nthe size of the public key is: $ {public_key_length}");
        print!("\nthe size of the private key is: ${private_key_length}");
    }
}
