{
  inputs,
  nixpkgs,
  small,
  system,
  user,
  lib,
  ...
}: let
  # pkgs = import ../../pkgs {inherit inputs nixpkgs system lib;};
  steamPkgs = import ../../pkgs/steam.nix {inherit inputs nixpkgs small system lib;};
  headlessPkgs = import ../../pkgs/headless.nix {inherit inputs nixpkgs system lib;};
in {
  desktop = import ../../lib/mkMachine.nix {
    inherit inputs nixpkgs system lib user;
    path = ./machines/desktop;
    pkgs = steamPkgs;
  };
  laptop = import ../../lib/mkMachine.nix {
    inherit inputs nixpkgs system lib user;
    path = ./machines/laptop;
    pkgs = steamPkgs;
  };
  libreboot = import ../../lib/mkMachine.nix {
    inherit inputs nixpkgs system lib user;
    path = ./machines/libreboot;
    pkgs = steamPkgs;
  };
  server = import ../../lib/mkMachine.nix {
    inherit inputs nixpkgs system lib user;
    path = ./machines/server;
    pkgs = headlessPkgs;
  };
  wsl = import ../../lib/mkMachine.nix {
    inherit inputs nixpkgs system lib user;
    path = ./machines/wsl;
    pkgs = headlessPkgs;
  };
}
