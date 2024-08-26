{
  user,
  config,
  ...
}: {
  imports = [../../shared];
  config = {
    modules = {
      machine = {
        kind = "desktop";
      };
      users = {
        inherit user;
      };
      boot = {
        secureboot = {
          enable = true;
        };
      };
      gpu = {
        enable = true;
        amd = {
          enable = true;
        };
      };
      security = {
        enable = true;
        sudo = {
          noPassword = true;
        };
        sops = {
          enable = true;
        };
      };
      virtualisation = {
        enable = true;
      };
      networking = {
        enable = true;
        wireshark = {
          enable = true;
        };
        bluetooth = {
          enable = true;
        };
        torrent = {
          enable = true;
          mullvadAccountSecretPath = config.sops.secrets.mullvad.path;
        };
        irc = {
          enable = true;
          weechat = {
            enable = true;
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
      gaming = {
        enable = true;
        steam = {
          enable = true;
        };
      };
      crypto = {
        ledger-live = {
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
            explorer = {
              dolphin = {
                enable = true;
              };
            };
            networking = {
              enable = true;
              proxy = {
                enable = true;
                mitmproxy = {
                  enable = true;
                };
              };
              irc = {
                enable = true;
                pidgin = {
                  enable = true;
                };
              };
            };
            editor = {
              zed = {
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
            operations = {
              enable = true;
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
