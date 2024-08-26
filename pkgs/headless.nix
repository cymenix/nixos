{
  inputs,
  nixpkgs,
  system,
  lib,
  ...
}: let
  config = import ./config lib;
  overlays = import ./overlays/headless {inherit inputs nixpkgs system;};
in
  import nixpkgs {
    inherit system config overlays;
  }
