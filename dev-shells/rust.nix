{mkShell, stable, unstable, ...}: 
mkShell rec { 
  name = "ncn-rust-env";

  stablePackages = with stable; [
    cargo
    rustc
    rustfmt

    openssl
    pkg-config
  ];

  unstablePackages = with unstable; [
    jetbrains.rust-rover
  ];

  packages = stablePackages ++ unstablePackages;
}
