{
  config,
  pkgs,
  ...
}: let
  inherit (config.modules.users) user uid;
  secrets = "/run/user/${builtins.toString uid}/secrets";
in {
  sops = {
    defaultSopsFile = ../secrets/secrets.yaml;
    secrets = {
      password = {
        neededForUsers = true;
      };
      wifi = {
        neededForUsers = true;
      };
      mullvad = {
        neededForUsers = true;
      };
    };
  };
  home-manager = {
    users = {
      ${user} = {
        home = {
          packages = [
            (import ./scripts/setupserver.nix {inherit pkgs;})
            (import ./scripts/deleteserver.nix {inherit pkgs;})
          ];
        };
        programs = {
          zsh = {
            initExtra = let
              gh_token =
                if config.modules.security.sops.enable
                then ''
                  if [[ -o interactive ]]; then
                    export GH_TOKEN=$(${pkgs.bat}/bin/bat ${config.home-manager.users.${user}.sops.secrets.github_token.path} --style=plain)
                  fi
                ''
                else "";
              hetzner_token =
                if config.modules.security.sops.enable
                then ''
                  if [[ -o interactive ]]; then
                    export HCLOUD_TOKEN=$(${pkgs.bat}/bin/bat ${config.home-manager.users.${user}.sops.secrets.hetzner_token.path} --style=plain)
                  fi
                ''
                else "";
            in
              /*
              bash
              */
              ''
                ${builtins.toString gh_token}
                ${builtins.toString hetzner_token}
              '';
          };
        };
        nix = {
          extraOptions = ''
            !include ${config.home-manager.users.${user}.sops.secrets.nix_access_tokens.path}
          '';
        };
        sops = {
          defaultSopsFile = ../secrets/secrets.yaml;
          secrets = {
            "email/clemens.horn@mni.thm.de/password" = {
              path = "${secrets}/email/clemens.horn@mni.thm.de/password";
            };
            "email/horn_clemens@t-online.de/password" = {
              path = "${secrets}/email/horn_clemens@t-online.de/password";
            };
            "email/me@clemenshorn.com/password" = {
              path = "${secrets}/email/me@clemenshorn.com/password";
            };
            github_token = {
              path = "${secrets}/github_token";
            };
            hetzner_token = {
              path = "${secrets}/hetzner_token";
            };
            nix_access_tokens = {
              path = "${secrets}/nix_access_tokens";
            };
            thmvpnuser = {
              path = "${secrets}/thmvpnuser";
            };
            thmvpnpass = {
              path = "${secrets}/thmvpnpass";
            };
          };
        };
      };
    };
  };
}
