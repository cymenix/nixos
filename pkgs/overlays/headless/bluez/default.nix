nixpkgs: system: let
  pkgs = import nixpkgs {inherit system;};
in
  self: super: {
    bluez = super.bluez.overrideAttrs (finalAttrs: previousAttrs: {
      version = "5.76";
      src = pkgs.fetchurl {
        url = "mirror://kernel/linux/bluetooth/bluez-${finalAttrs.version}.tar.xz";
        hash = "sha256-VeLGRZCa2C2DPELOhewgQ04O8AcJQbHqtz+s3SQLvWM=";
      };
    });
  }
