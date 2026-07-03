# NixOS Config

JuicyGoose007's NixOS flake — niri + home-manager + stylix + nixvim.

## Fresh Install

### 1. Partition, format, mount, then generate hardware config:

**Confirm the target disk first** — this wipes the whole drive:
```sh
lsblk -o NAME,SIZE,TYPE,FSTYPE,LABEL,MOUNTPOINT
```
On this machine the NixOS drive is `/dev/sda` (223.6 GB SATA SSD).
**Do NOT touch** `sdb` (Windows/BitLocker), `nvme1n1` (Games), or `nvme0n1`.
Everything below writes to `/dev/sda` only — adjust the device name if it differs.

Partition (GPT: 1 GB ESP + root + 8 GB swap):
```sh
sudo parted /dev/sda -- mklabel gpt
sudo parted /dev/sda -- mkpart ESP fat32 1MiB 1025MiB
sudo parted /dev/sda -- set 1 esp on
sudo parted /dev/sda -- mkpart primary 1025MiB -8GiB
sudo parted /dev/sda -- mkpart primary linux-swap -8GiB 100%
```

Format and activate swap:
```sh
sudo mkfs.fat -F 32 -n boot /dev/sda1
sudo mkfs.ext4 -L nixos /dev/sda2
sudo mkswap  -L swap  /dev/sda3
sudo swapon /dev/sda3          # MUST be active before generate-config so swap is captured
```

Mount:
```sh
sudo mount /dev/disk/by-label/nixos /mnt
sudo mkdir -p /mnt/boot
sudo mount /dev/disk/by-label/boot /mnt/boot
```

Generate hardware config (picks up the active swap automatically):
```sh
sudo nixos-generate-config --root /mnt
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

### 4. Set your user password (required — the login greeter needs it):
The `juicygoose007` account has no password until you set one. Do this before
rebooting, or you'll be stuck at the greeter.
```sh
sudo passwd juicygoose007
```

### 5. Reboot into niri.

---

The script saves your machine-specific `hardware-configuration.nix`, clones this repo to `/etc/nixos`, restores it, then runs `nixos-rebuild switch`. Home-manager deploys all dotfiles automatically.

## Day-to-day rebuild

```sh
sudo nixos-rebuild switch --flake /etc/nixos#nixos
```
