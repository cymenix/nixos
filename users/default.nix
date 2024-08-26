{
  inputs,
  nixpkgs,
  small,
  system,
  lib,
  ...
}: let
  mkUser = user: import ./${user} {inherit inputs nixpkgs small system user lib;};
in {
  clay = mkUser "clay";
  mo = mkUser "mo";
}
