{pkgs}:
with pkgs;
  writeShellScriptBin "setupserver"
  /*
  bash
  */
  ''
    NAME="$1"
    SERVER_FLAKE="$2"
    SERVER_CONFIGURATION="$SERVER_FLAKE/configuration.nix"
    PRIVATE_KEY="$HOME/.ssh/id_ed25519_$NAME"
    PUBLIC_KEY="$HOME/.ssh/id_ed25519_$NAME.pub"
    IMAGE="ubuntu-24.04"
    SERVER_TYPE="cpx21"
    SERVER_LOCATION="fsn1"

    if [ -z "$NAME" ]; then
      echo "Error: The first argument (NAME) is required."
      exit 1
    fi

    if [ -z "$SERVER_FLAKE" ]; then
      echo "Error: The second argument (SERVER_FLAKE) is required."
      exit 1
    fi

    echo "Generating SSH key pair for $NAME..."
    ${openssh}/bin/ssh-keygen -t ed25519 -f $PRIVATE_KEY -N ""

    echo "Creating SSH key on Hetzner Cloud..."
    ${hcloud}/bin/hcloud ssh-key create --name $NAME --public-key-from-file $PUBLIC_KEY

    echo "Creating server $NAME on Hetzner Cloud..."
    ${hcloud}/bin/hcloud server create --name $NAME --image $IMAGE --type $SERVER_TYPE --location $SERVER_LOCATION --ssh-key $NAME

    echo "Overwriting $SERVER_CONFIGURATION"
    cat << EOF > $SERVER_CONFIGURATION
    {
      modulesPath,
      ...
    }:
      let
        sshKey = # CHANGE
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
    EOF

    echo "  users.users.$NAME.openssh.authorizedKeys.keys = [sshKey];" >> $SERVER_CONFIGURATION
    echo "}" >> $SERVER_CONFIGURATION

    echo "Updating SSH key in $SERVER_CONFIGURATION"
    sed -i "s|# CHANGE|\"$(cat $PUBLIC_KEY)\";|" $SERVER_CONFIGURATION

    echo "Fetching server IP address..."
    SERVER_IP="$(${hcloud}/bin/hcloud server ip $NAME)"

    echo "Installing NixOS using nixos-anywhere..."
    nix run github:nix-community/nixos-anywhere -- -f $SERVER_FLAKE#$NAME -i $PRIVATE_KEY root@$SERVER_IP

    NIX_SSHOPTS="-o IdentitiesOnly=yes -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i $PRIVATE_KEY"

    ${openssh}/bin/scp $NIX_SSHOPTS -r $SERVER_FLAKE/* $NAME@$SERVER_IP:~/.config/flake/

    echo "Removing server IP from known_hosts..."
    ${openssh}/bin/ssh-keygen -f ~/.ssh/known_hosts -R $SERVER_IP

    echo "Done! Connecting to $NAME"
    echo "ssh $NIX_SSHOPTS root@$SERVER_IP"
    ${openssh}/bin/ssh $NIX_SSHOPTS $NAME@$SERVER_IP
  ''
