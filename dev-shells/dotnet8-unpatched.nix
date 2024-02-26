{mkShell, stable, unstable} : 
mkShell rec {
  name = "ncn-dotnet7-env";


  stablePackages = with stable; [
    (with dotnetCorePackages; combinePackages [
      sdk_6_0
      sdk_7_0
      sdk_8_0
    ])
  ];

  unstablePackages = with unstable; [
    unstable.jetbrains.rider
  ];

  packages = stablePackages ++ unstablePackages;
}
