# Arch KDE Plasma Sync

This repository contains your KDE Plasma configs, system package lists, and scripts for backup and auto-sync. It allows you to replicate your Arch + KDE setup on any machine and keeps it synchronized with GitHub.

---

## Features

- Backup and restore KDE configs (`~/.config`, `~/.local/share`, `~/.kde`)  
- Backup and restore installed packages (official and AUR)  
- Auto-sync at Plasma login with KDE popup notifications  
- Safety check prevents overwriting uncommitted local changes  
- Fully automated one-step setup for new machines  

---

## One-Step Installation (Fresh Arch + KDE)

Open a terminal on a fresh Arch + KDE install and copy-paste:

```bash
REPO="$HOME/dotfiles"; GIT_URL="https://github.com/flaggx/arch_kde_plasma_sync"; sudo pacman -Sy --needed --noconfirm git rsync base-devel kdialog && [ ! -d "$REPO" ] && git clone "$GIT_URL" "$REPO"; cd "$REPO"; chmod +x arch_kde_sync.sh; ./arch_kde_sync.sh <<< 2; ./arch_kde_sync.sh <<< 3

What It Does

Installs required packages (git, rsync, base-devel, kdialog).

Clones this repository to ~/dotfiles.

Restores all packages listed in the repo (official + AUR).

Restores KDE configs and links them to your home directory.

Sets up auto-sync at Plasma login with KDE notifications and safety checks.

Quick Start – KDE Auto-Sync Notifications

After running the one-step installer, your system automatically syncs your dotfiles every time you log into KDE Plasma.

1. Uncommitted Changes Warning

If you have local changes that haven’t been committed, KDE will show:

Dotfiles Auto-Sync
WARNING: You have uncommitted changes in your dotfiles repo! Auto-sync skipped.


Action: Commit or stash your changes before the next login.

2. Successful Sync Notification

When auto-sync completes:

Dotfiles Auto-Sync
Dotfiles auto-sync completed successfully.


KDE configs and packages are up to date.

New changes are pushed to GitHub automatically.

3. Log Out and Log Back In

The first login triggers the initial auto-sync.

Subsequent logins auto-sync your dotfiles automatically.

4. Optional Manual Trigger

Run the auto-sync manually anytime:

cd ~/dotfiles
./arch_kde_sync.sh <<< 3

Notes

Only system configs and KDE-specific files are backed up (excludes Documents, Downloads, Pictures).

Auto-sync uses safety checks to prevent overwriting local changes.

KDE notifications require kdialog (installed automatically by the one-step installer).
