{
  inputs = {
    stable.url = "github:NixOS/nixpkgs/master";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {self, stable, unstable, flake-utils}:
    let 
      # reuse
      defaultSystem = "x86_64-linux";
      passPkgsInputs = {
        system = defaultSystem;
        config = {
          allowUnfree = true;
          android_sdk.accept_license = true;
        };
      };
      stablePkgs = import stable passPkgsInputs;
      unstablePkgs = import unstable passPkgsInputs;

      # shells
      mkDevShell = import ./dev-shells.nix;
      mkShell = stablePkgs.mkShell;
      passShellInputs = { inherit mkShell stablePkgs unstablePkgs; };

      final = {
        eval = 2 + 2;
        devShells.${defaultSystem} = {
          node = mkDevShell.nodeShell passShellInputs;
          dotnet = mkDevShell.dotnetShell passShellInputs;
          rn = mkDevShell.reactNativeShell passShellInputs;
        };
      };

    in final;
}