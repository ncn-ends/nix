{ inputs, system, ...} : 
let 
  # applyConfig = pkg: pkg.extend (final: prev: {
  #   config.allowUnfree = true;
  # });
  passPksImportInput = { inherit system; config.allowUnfree = true; };
in rec {
  oldstable.${system} = import inputs.oldstable passPksImportInput;
  stable.${system} = import inputs.stable passPksImportInput;
  unstable.${system} = import inputs.unstable passPksImportInput;
  untested.${system} = import inputs.untested passPksImportInput;
  # oldstable = applyConfig oldstable.legacyPackages.${system};
  # stable = applyConfig inputs.stable.legacyPackages.${system};
  # unstable = applyConfig inputs.unstable.legacyPackages.${system};
  # untested = applyConfig inputs.untested.legacyPackages.${system};
  # overrides = import ./apply-overrides.nix { packages = stable; };
}