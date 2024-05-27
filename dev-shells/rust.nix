{mkShell, imports, ...}: 
mkShell rec { 
  name = "ncn-rust-env";

  packages = let 
    inherit (imports.stable) cargo rustc rustfmt openssl pkg-config;
    inherit (imports.unstable) jetbrains;
  in [
    cargo
    rustc
    rustfmt
    openssl
    pkg-config
    jetbrains.rust-rover
  ];
}
