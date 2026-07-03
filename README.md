# NixOS Config

JuicyGoose007's NixOS flake — niri + home-manager + stylix + nixvim.

## Fresh Install

### 1. Partition, format, and mount your disks, then generate hardware config:
If you want swap, run `swapon` on your swap partition **before** generating the
config so it gets picked up automatically.
```sh
nixos-generate-config --root /mnt
```

### 2. Install the base system and set a root password:
```sh
nixos-install
reboot
```

### 3. Boot into the base NixOS system, then run:
```sh
curl -fsSL https://raw.githubusercontent.com/JuicyGoose007-coder/Nixos-config/master/install.sh | sudo bash
```

Or without internet access:
```sh
git clone https://github.com/JuicyGoose007-coder/Nixos-config.git /tmp/nixos-config
sudo bash /tmp/nixos-config/install.sh
```

### 4. Reboot into niri.

---

The script saves your machine-specific `hardware-configuration.nix`, clones this repo to `/etc/nixos`, restores it, then runs `nixos-rebuild switch`. Home-manager deploys all dotfiles automatically.

## Day-to-day rebuild

```sh
sudo nixos-rebuild switch --flake /etc/nixos#nixos
```
