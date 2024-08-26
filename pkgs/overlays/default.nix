{
  inputs,
  nixpkgs,
  small,
  system,
}: let
  smallPkgs = import small {inherit system;};
  smallOverlays = [(final: prev: {inherit (smallPkgs) rocmPackages rocmPackages_6;})];
  headlessOverlays = import ./headless {inherit inputs nixpkgs system;};
  guiOverlays = import ./gui inputs;
in
  headlessOverlays ++ guiOverlays ++ smallOverlays
