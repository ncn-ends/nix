{ inputs, system, ...} : 
let 
  passPksImportInput = { inherit system; config.allowUnfree = true; };
in rec {
  oldstable = import inputs.oldstable passPksImportInput;
  stable = import inputs.stable passPksImportInput;
  unstable = import inputs.unstable passPksImportInput;
  untested = import inputs.untested passPksImportInput;
  overrides = import ./apply-overrides.nix { packages = stable; };
}