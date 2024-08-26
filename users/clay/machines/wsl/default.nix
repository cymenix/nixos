{
  user,
  config,
  ...
}: {
  config = {
    modules = {
      machine = {
        kind = "wsl";
      };
      users = {
        name = user;
      };
      security = {
        sudo = {
          noPassword = true;
        };
      };
    };
    home-manager = {
      users = {
        "${config.modules.users.user}" = {
          modules = {
            media = {
              enable = true;
              audio = {
                enable = false;
              };
              communication = {
                enable = false;
              };
              editing = {
                enable = false;
              };
              games = {
                enable = false;
              };
              video = {
                enable = false;
              };
              music = {
                enable = true;
                dlplaylist = {
                  enable = true;
                };
                spotdl = {
                  enable = true;
                };
                ncmpcpp = {
                  enable = false;
                };
                spotify = {
                  enable = false;
                };
              };
            };
            editor = {
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
          };
        };
      };
    };
  };
}
