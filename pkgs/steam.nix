{
  inputs,
  nixpkgs,
  small,
  system,
  lib,
  ...
}: let
  config = import ./config/steam lib;
  overlays = import ./overlays {inherit inputs nixpkgs small system;};
in
  import nixpkgs {
    inherit system config overlays;
  }
