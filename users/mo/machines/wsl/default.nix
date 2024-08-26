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
          modules = {};
        };
      };
    };
  };
}
