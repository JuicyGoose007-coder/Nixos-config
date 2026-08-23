# NixOS Config

JuicyGoose007's NixOS flake — niri + home-manager + stylix + nixvim.
One host `goosenest`, one user `juicygoose007`.

## Install

On a base NixOS system installed as `juicygoose007`:

```sh
curl -fsSL https://raw.githubusercontent.com/JuicyGoose007-coder/Nixos-config/master/install.sh | sudo bash
```

Offline:

```sh
git clone https://github.com/JuicyGoose007-coder/Nixos-config.git /tmp/nixos-config
sudo bash /tmp/nixos-config/install.sh
```

Then:

```sh
sudo passwd juicygoose007    # unless the installer set one
vim +PlugInstall +qa         # nixvim comes from the flake; plain vim does not
```

Reboot into niri, then commit the `hardware-configuration.nix` that
`install.sh` restored so the repo matches the machine.

## Rebuild

```sh
nx           # build, diff, switch
nx -n        # dry run
nx up        # update flake.lock first
nx back      # roll back one generation
nx clean 5   # keep the newest 5 generations, collect garbage
```
