cd rust
cargo fetch
cargo test
cargo build --release




cd ..
flutter clean
flutter pub get
flutter_rust_bridge_codegen generate
cd example
flutter test integration_test/master_integration_test.dart -d linux

