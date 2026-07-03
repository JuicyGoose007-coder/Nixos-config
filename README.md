# NixOS Config

JuicyGoose007's NixOS flake — niri + home-manager + stylix + nixvim.

## Fresh Install

Both paths do the same thing: get a **bootable base NixOS system** onto the disk,
then run `install.sh` on it to layer this flake on top. Pick **one** of Option A
or Option B, then follow **"After the base system boots"** (same for both).

## Option A — Minimal ISO (command line)

**1.** Partition, format, and mount your disks, then generate the hardware config.
If you want swap, run `swapon` on your swap partition **before** generating so it
gets picked up automatically:
```sh
sudo nixos-generate-config --root /mnt
```

**2.** Install the base system (prompts for a root password), then reboot:
```sh
nixos-install
reboot
```

## Option B — Graphical ISO (Calamares wizard)

The wizard handles partitioning, formatting, **hardware-config generation, and the
install itself** — you do **not** run `nixos-generate-config` or `nixos-install`
by hand. In the wizard:

- **Disk:** install to your target disk only. "Erase disk" wipes just the drive
  you select — make sure you don't pick one of your other drives. If unsure, use
  **Manual partitioning** and only touch the target disk.
- **User:** set the username to exactly **`juicygoose007`** and give it a
  password. Because the config uses `mutableUsers = true`, this password carries
  over — so you can skip the `passwd` step below.
- **Swap:** choose **"Swap (no Hibernate)"** (auto-sizes, often ≈ RAM), or use
  Manual partitioning for an exact 8 GB `linux-swap` partition.

Everything else the wizard sets (desktop, hostname, its `configuration.nix`) is
**discarded** by `install.sh`. When it finishes, **reboot** into the new system.

## After the base system boots (both paths)

**1.** Apply this flake:
```sh
curl -fsSL https://raw.githubusercontent.com/JuicyGoose007-coder/Nixos-config/master/install.sh | sudo bash
```
Or without internet access:
```sh
git clone https://github.com/JuicyGoose007-coder/Nixos-config.git /tmp/nixos-config
sudo bash /tmp/nixos-config/install.sh
```

**2.** Set your user password — **Option A only** (Option B already set it in the
wizard). Otherwise `juicygoose007` has no password and you'll be stuck at the
greeter:
```sh
sudo passwd juicygoose007
```

**3.** Reboot into niri.

**4.** Commit the regenerated hardware config. `install.sh` restores this machine's
fresh `hardware-configuration.nix` (new partition UUIDs, swap entry) but leaves it
uncommitted — commit it so the repo matches the machine:
```sh
cd /etc/nixos
git add hardware-configuration.nix
git commit -m "hardware-configuration: post-reinstall (new UUIDs + swap)"
git push
```

---

The script saves your machine-specific `hardware-configuration.nix`, clones this repo to `/etc/nixos`, restores it, then runs `nixos-rebuild switch`. Home-manager deploys all dotfiles automatically.

## Day-to-day rebuild

```sh
sudo nixos-rebuild switch --flake /etc/nixos#nixos
```
