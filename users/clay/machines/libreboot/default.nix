{
  user,
  config,
  ...
}: {
  imports = [../../shared];
  config = {
    modules = {
      machine = {
        kind = "laptop";
        name = "libreboot";
      };
      boot = {
        efiSupport = false;
      };
      users = {
        inherit user;
      };
      gaming = {
        enable = true;
        steam = {
          enable = false;
        };
      };
      networking = {
        enable = true;
        torrent = {
          enable = true;
          mullvadAccountSecretPath = config.sops.secrets.mullvad.path;
        };
        irc = {
          enable = true;
          weechat = {
            enable = false;
          };
        };
        vpn = {
          enable = true;
          thm = {
            enable = true;
            usernameFile = config.home-manager.users.${user}.sops.secrets.thmvpnuser.path;
            passwordFile = config.home-manager.users.${user}.sops.secrets.thmvpnpass.path;
          };
        };
        wireless = {
          enable = true;
          eduroam = {
            enable = true;
          };
        };
      };
      security = {
        sudo = {
          noPassword = true;
        };
        sops = {
          enable = true;
        };
      };
    };
    home-manager = {
      users = {
        ${user} = {
          modules = {
            development = {
              reversing = {
                enable = true;
              };
            };
            networking = {
              enable = true;
              proxy = {
                enable = true;
              };
              irc = {
                enable = true;
                pidgin = {
                  enable = true;
                };
              };
            };
            editor = {
              vscode = {
                enable = true;
              };
              nixvim = {
                development = {
                  languages = {
                    latex = {
                      enable = true;
                      vimtex = {
                        enable = true;
                      };
                    };
                    haskell = {
                      enable = true;
                      haskell-tools-nvim = {
                        enable = true;
                      };
                    };
                  };
                };
              };
            };
            security = {
              bitwarden = {
                enable = true;
              };
              ssh = {
                enable = true;
              };
              gpg = {
                enable = true;
              };
              sops = {
                enable = true;
              };
            };
          };
        };
      };
    };
  };
}
