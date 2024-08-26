{pkgs}:
with pkgs;
  writeShellScriptBin "deleteserver"
  /*
  bash
  */
  ''
    NAME="$1"
    PRIVATE_KEY="$HOME/.ssh/id_ed25519_$NAME"
    PUBLIC_KEY="$HOME/.ssh/id_ed25519_$NAME.pub"

    if [ -z "$NAME" ]; then
      echo "Error: The first argument (NAME) is required."
      exit 1
    fi

    rm $PRIVATE_KEY $PUBLIC_KEY
    ${hcloud}/bin/hcloud ssh-key delete $NAME
    ${hcloud}/bin/hcloud server delete $NAME
  ''
