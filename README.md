# NixOS Config

JuicyGoose007's NixOS flake — niri + home-manager + stylix + nixvim.

## Fresh Install

Pick **one** install path — **Option A** (minimal ISO, command line) or
**Option B** (graphical ISO, Calamares wizard) — then continue from **step 3**,
which is the same for both.

## Option A — Minimal ISO (command line)

### 1. Partition, format, and mount your disks, then generate hardware config:
If you want swap, run `swapon` on your swap partition **before** generating the
config so it gets picked up automatically.
```sh
sudo nixos-generate-config --root /mnt
```

### 2. Install the base system and set a root password:
```sh
nixos-install
reboot
```

## Option B — Graphical ISO (Calamares wizard)

Run the installer and, in the wizard:

- **Disk:** install to your target disk only. With "Erase disk" it wipes just
  the drive you select — make sure you don't pick one of your other drives. If
  unsure, use **Manual partitioning** and only touch the target disk.
- **User:** set the username to exactly **`juicygoose007`** and give it a
  password. Because the config uses `mutableUsers = true`, this password carries
  over — so you can skip step 4 later.
- **Swap:** choose **"Swap (no Hibernate)"** (auto-sizes, often ≈ RAM), or use
  Manual partitioning for an exact 8 GB `linux-swap` partition.

Everything else the wizard sets (desktop, hostname, its `configuration.nix`) is
**discarded** by `install.sh` — only `hardware-configuration.nix` is kept. When
it finishes, **reboot into the base system** and continue below.

## Both paths continue here

### 3. Boot into the base NixOS system, then run:
```sh
curl -fsSL https://raw.githubusercontent.com/JuicyGoose007-coder/Nixos-config/master/install.sh | sudo bash
```

Or without internet access:
```sh
git clone https://github.com/JuicyGoose007-coder/Nixos-config.git /tmp/nixos-config
sudo bash /tmp/nixos-config/install.sh
```

### 4. Set your user password (Option A only — the login greeter needs it):
On the minimal-ISO path the `juicygoose007` account has no password until you
set one. Do this before rebooting, or you'll be stuck at the greeter. (Option B
already set it in the wizard — skip this.)
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
