# Arch KDE Plasma Sync

This repository contains scripts and configurations to backup, restore, and auto-sync your Arch + KDE Plasma setup. It allows you to replicate your system on any machine and keep your dotfiles synchronized with GitHub.

---

## Features

- Backup and restore KDE configs (`~/.config`, `~/.local/share`, `~/.kde`)  
- Backup and restore installed packages (official + AUR)  
- Auto-sync at Plasma login with KDE popup notifications  
- Safety checks prevent overwriting uncommitted changes  
- Fully automated one-line setup for new machines  

---

## One-Line Installer (Fresh Arch + KDE)

Open a terminal and copy-paste this command:

```bash
REPO="$HOME/dotfiles"; GIT_URL="https://github.com/flaggx/arch_kde_plasma_sync"; \
sudo pacman -Sy --needed --noconfirm git rsync base-devel kdialog && \
git config --global user.name "Andrew Mathews" && \
git config --global user.email "flaggx@gmail.com" && \
[ ! -d "$REPO" ] && git clone "$GIT_URL" "$REPO"; cd "$REPO"; chmod +x arch_kde_sync.sh; ./arch_kde_sync.sh

What It Does

Installs required packages: git, rsync, base-devel, kdialog

Sets your global Git user name/email

Clones this repository to $HOME/dotfiles if it doesn’t exist

Makes arch_kde_sync.sh executable

Runs the script, which:

Restores packages and KDE configs

Sets up auto-sync at Plasma login

Usage

After setup, you can:

Restore manually:

cd ~/dotfiles
./arch_kde_sync.sh <<< 2


Setup auto-sync manually:

cd ~/dotfiles
./arch_kde_sync.sh <<< 3


Trigger auto-sync manually anytime:

cd ~/dotfiles
bash ~/.local/bin/arch_kde_auto_sync.sh

KDE Auto-Sync Notifications

After running the one-line installer, auto-sync runs every time you log into Plasma.

Uncommitted Changes Warning

If local changes exist, KDE will show:

Dotfiles Auto-Sync
WARNING: Uncommitted changes! Auto-sync skipped.


Successful Sync Notification

After a successful sync:

Dotfiles Auto-Sync
Dotfiles auto-sync completed successfully.

Notes

Only system configs and KDE-specific files are backed up (excludes Documents, Downloads, Pictures)

Auto-sync uses safety checks to avoid overwriting local changes

KDE notifications require kdialog (installed automatically by the one-line installer)

License

MIT License



