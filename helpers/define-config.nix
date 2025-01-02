{...} : 
let 
  imports = import ./helpers/import-packages.nix { system = machine.system; inputs; };
  lib = inputs.stable.lib;
  callPackage = imports.stable.callPackage;
in{

}