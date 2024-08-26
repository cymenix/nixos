{
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };
    cymenixos = {
      url = "github:cymenix/os";
    };
  };

  outputs = {
    nixpkgs,
    cymenixos,
    ...
  } @ inputs: let
    inherit (nixpkgs) lib;
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
    };
    user = "cache";
  in {
    nixosConfigurations = {
      cache = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit lib nixpkgs system pkgs user;
          inputs = inputs // cymenixos.inputs;
        };
        modules = [
          inputs.disko.nixosModules.disko
          cymenixos.nixosModules.${system}.default
          ./configuration.nix
          {
            nix = {
              nixPath = ["nixpkgs=${nixpkgs}"];
            };
            nixpkgs = {
              hostPlatform = system;
            };
            modules = {
              machine = {
                kind = "server";
              };
              users = {
                inherit user;
              };
              security = {
                gnome-keyring = {
                  enable = false;
                };
                gnupg = {
                  enable = false;
                };
                polkit = {
                  enable = false;
                };
                rtkit = {
                  enable = false;
                };
                tpm = {
                  enable = false;
                };
                sudo = {
                  noPassword = true;
                };
              };
            };
          }
        ];
      };
    };
  };
}
