use crate::api::mode::MldsaMode;
use crate::api::simple::KeypairModel;

#[test]
fn mldsa_all_modes_work() {
    let msg = b"Thios is a totally randam santences withLats oF TpYo".to_vec();

    let mode_list = [MldsaMode::Mldsa44, MldsaMode::Mldsa65, MldsaMode::Mldsa87];
    for mode in mode_list {
        println!("\n\n ###################-Mldsa Mode: {:?}-###################", mode);
        println!("The message is :\n{:?}", msg.to_vec());
        let keys = KeypairModel::generate(mode);
        print!("\nKeypair public/private key conform to the expected size");
        let public_key = keys.public_key();
        let private_key = keys.private_key();

        let public_key_length = keys.public_key().len();
        let private_key_length = keys.private_key().len();

        let sig_bytes = KeypairModel::sign_message(mode, private_key, msg.clone()).unwrap();
        print!("\nThe signature is generated correctly");
        let result = KeypairModel::verify_sig(mode, public_key, sig_bytes, msg.clone());
        assert_eq!(result, true);

        println!("\nThe result of verification is: {:?}", result);
        print!("\nthe size of the public key is: $ {public_key_length}");
        print!("\nthe size of the private key is: ${private_key_length}");
    }
}
