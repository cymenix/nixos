{
  modulesPath,
  ...
}:
  let
    sshKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB2u73Yrv02L0809pJ9WBSg5okNZ9Oq8sYW3H2jFJZNe clay@cymenix";
  in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
  ];

  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  users.users.root.openssh.authorizedKeys.keys = [sshKey];
  users.users.cache.openssh.authorizedKeys.keys = [sshKey];
}
