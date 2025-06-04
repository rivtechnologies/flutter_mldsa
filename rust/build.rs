fn main() {
    let target = std::env::var("TARGET").unwrap();
    let profile = std::env::var("PROFILE").unwrap();

    if target == "wasm32-unknown-unknown" && profile == "debug" {
        eprintln!("Error: Building for wasm32-unknown-unknown in debug mode is not supported.");
        std::process::exit(1);
    }
}
