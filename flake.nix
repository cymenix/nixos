{
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable-small";
    };
    small = {
      url = "github:NixOS/nixpkgs/nixos-unstable-small";
    };
    master = {
      url = "github:NixOS/nixpkgs/master";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
    cymenixos = {
      url = "github:cymenix/os";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };
  };
  outputs = {
    nixpkgs,
    master,
    small,
    flake-utils,
    cymenixos,
    ...
  } @ inputs:
    flake-utils.lib.eachDefaultSystem (
      system: let
        inherit (nixpkgs) lib;
        pkgs = import nixpkgs {inherit system;};
      in {
        formatter = pkgs.alejandra;
        packages = {
          nixosConfigurations = import ./users {
            inherit nixpkgs small system lib;
            inputs = inputs // cymenixos.inputs // cymenixos.inputs.nvim.inputs;
          };
        };
      }
    );
}
