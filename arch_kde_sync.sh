#!/bin/bash
# =========================================
# Arch + KDE Plasma Backup & Restore Script
# Only backs up configs & packages, with Git auto-sync at Plasma login
# Includes safety check and KDE notifications
# =========================================

# -----------------------------
# CONFIGURATION
# -----------------------------
REPO="$HOME/dotfiles"
GIT_REMOTE_URL="https://github.com/flaggx/arch_kde_plasma_sync.git"
AUTO_SYNC_SCRIPT="$HOME/.local/bin/arch_kde_auto_sync.sh"
AUTOSTART_DIR="$HOME/.config/autostart-scripts"

# -----------------------------
# FUNCTIONS
# -----------------------------

setup_repo() {
    mkdir -p "$REPO/config" "$REPO/share" "$REPO/kde" "$REPO/scripts" "$REPO/pkglist"
}

backup_configs() {
    rsync -a --progress ~/.config/ "$REPO/config/"
    rsync -a --progress ~/.local/share/ "$REPO/share/"
    [ -d ~/.kde ] && rsync -a --progress ~/.kde/ "$REPO/kde/"
    pacman -Qqe > "$REPO/pkglist/pacman.txt"
    if command -v yay &>/dev/null; then
        yay -Qqe > "$REPO/pkglist/aur.txt"
    fi
}

create_symlink_script() {
    cat << 'EOL' > "$REPO/scripts/link_dotfiles.sh"
#!/bin/bash
REPO="$HOME/dotfiles"
mkdir -p ~/.config
for dir in $(ls "$REPO/config"); do ln -sf "$REPO/config/$dir" "$HOME/.config/$dir"; done
mkdir -p ~/.local/share
for dir in $(ls "$REPO/share"); do ln -sf "$REPO/share/$dir" "$HOME/.local/share/$dir"; done
if [ -d "$REPO/kde" ]; then mkdir -p ~/.kde; for dir in $(ls "$REPO/kde"); do ln -sf "$REPO/kde/$dir" "$HOME/.kde/$dir"; done; fi
EOL
    chmod +x "$REPO/scripts/link_dotfiles.sh"
}

create_restore_script() {
    cat << 'EOL' > "$REPO/scripts/restore.sh"
#!/bin/bash
REPO="$HOME/dotfiles"
PKGLIST="$REPO/pkglist"
sudo pacman -Syu --needed - < "$PKGLIST/pacman.txt"
if [ -f "$PKGLIST/aur.txt" ]; then
    if ! command -v yay &>/dev/null; then
        git clone https://aur.archlinux.org/yay.git /tmp/yay
        cd /tmp/yay
        makepkg -si
    fi
    yay -S --needed - < "$PKGLIST/aur.txt"
fi
bash "$REPO/scripts/link_dotfiles.sh"
EOL
    chmod +x "$REPO/scripts/restore.sh"
}

git_auto_backup() {
    cd "$REPO"
    if [ ! -d ".git" ]; then git init; git branch -M main; git remote add origin "$GIT_REMOTE_URL"; fi
    git add .
    git commit -m "Auto backup: $(date +'%Y-%m-%d %H:%M:%S')" || echo "No changes to commit"
    git push -u origin main
}

setup_auto_sync_login() {
    mkdir -p "$AUTOSTART_DIR"
    cat << 'EOL' > "$AUTO_SYNC_SCRIPT"
#!/bin/bash
REPO="$HOME/dotfiles"
cd "$REPO"
notify() { command -v kdialog &>/dev/null && kdialog --title "Dotfiles Auto-Sync" --passivepopup "$1" 5 || echo "$1"; }
[[ -n $(git status --porcelain) ]] && notify "WARNING: Uncommitted changes! Auto-sync skipped." && exit 1
git pull origin main
bash "$REPO/scripts/link_dotfiles.sh"
git add .
git commit -m "Auto-sync at login: $(date +'%Y-%m-%d %H:%M:%S')" || true
git push origin main
notify "Dotfiles auto-sync completed successfully."
EOL
    chmod +x "$AUTO_SYNC_SCRIPT"
    cp "$AUTO_SYNC_SCRIPT" "$AUTOSTART_DIR/"
}

# -----------------------------
# MAIN LOGIC
# -----------------------------
echo "Choose an option:"
echo "1) Backup current system to dotfiles repo and push to GitHub"
echo "2) Restore system from dotfiles repo"
echo "3) Setup auto-sync at Plasma login (requires repo already cloned)"
read -p "Enter 1, 2, or 3: " choice

case "$choice" in
    1)
        setup_repo
        backup_configs
        create_symlink_script
        create_restore_script
        git_auto_backup
        echo "Backup completed."
        ;;
    2)
        if [ ! -d "$REPO" ]; then
            echo "Dotfiles repo not found at $REPO. Clone it first."
            exit 1
        fi
        bash "$REPO/scripts/restore.sh"
        ;;
    3)
        if [ ! -d "$REPO" ]; then
            echo "Dotfiles repo not found at $REPO. Clone it first."
            exit 1
        fi
        setup_auto_sync_login
        ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac
