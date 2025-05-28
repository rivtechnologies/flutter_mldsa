sudo apt-get update
sudo apt-get install -y \
            cmake \
            libgtk-3-dev \
            # ninja-build \
            # pkg-config \
            # liblzma-dev \
            # libstdc++6 \
            # libgl1-mesa-dev \
            # libegl1-mesa-dev \
            # libxcb1-dev \
            # libx11-dev \
            # libgdk-pixbuf2.0-dev \
            # libssl-dev

flutter config --enable-linux-desktop
sudo apt-get install -y xvfb
cargo install flutter_rust_bridge_codegen
flutter_rust_bridge_codegen generate

cd rust
crago fetch
crago test -- --show-output
cargo build --release

cd ..
flutter clean
flutter pub get
cd example
xvfb-run --auto-servernum -- flutter test -d linux integration_test/master_integration_test.dart


