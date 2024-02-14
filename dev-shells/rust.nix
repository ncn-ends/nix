{mkShell, stable, unstable, ...}: 
mkShell rec { 
  name = "ncn-rust-env";

  packages = let 
    inherit (stable) cargo rustc rustfmt openssl pkg-config;
    inherit (unstable) jetbrains;
  in [
    cargo
    rustc
    rustfmt
    openssl
    pkg-config
    jetbrains.rust-rover
  ];
}
