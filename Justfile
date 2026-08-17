#!/bin/just --justfile

set export
set positional-arguments
set dotenv-load
set dotenv-filename := ".env"

# -- ENVs

PROJECT_NAME := file_name(env("PWD", "devcontainer"))
BACKUP_DIRECTORY := `echo ${BACKUP:-/run/media/$USER/Storage/Backup}`

# -- Colors

DIM := '\033[2m'

# -- Recipes

# Show available recipes
_default:
    @just --list --unsorted
_run +cmd:
    #!/bin/bash
    set -euo pipefail
    #  "+cmd"
    printf "\n{{ BOLD }}{{ CYAN }} \uf054 %s{{ NORMAL }}\n\n" "$*" >&2
    if "$@"; then
        # ✓ done
        printf "\n{{ GREEN }} \u2713 done {{ NORMAL }}\n\n" "$*" >&2
    else
        code=$?
        # ☓ $code
        printf "\n{{ DIM }} \u2613 %s{{ NORMAL }}\n\n" "$code" >&2
        exit $code
    fi
# ✓ Skipping "recipe" : "reason"
_skip_msg recipe reason:
    @printf '\n{{ BLUE }} \u2713 Skipping "{{ recipe }}"{{ NORMAL }} : {{ DIM }}{{ reason }}{{ NORMAL }}\n\n' "$*" >&2

# ! ERROR : message
_error_msg message:
    @printf '\n {{ RED }}{{ BOLD }} ! ERROR\t{{ message }}{{ NORMAL }}\n'

# DIM & BOLD message
_msg message:
    @printf '\n {{ DIM }}{{ BOLD }} {{ message }}{{ NORMAL }}\n'

# Load .env file variables
[group('dev')]
load_env +cmd:
    #!/bin/bash
    set -euo pipefail
    get_secret(){ echo "$1"; }
    printf "\n{{ BOLD }}{{ DIM }} Loading env... {{ NORMAL }}\n\n" >&2
    if [ -f .env ]; then set -a; . ./.env; set +a; fi
    exec just _run "$@"

[group('dev')]
load_arch:
    @just load_env docker compose -f .devcontainer/compose.yaml \
     --profile arch up -d --force-recreate --build

# Bring down the devcontainer
[group('dev')]
devcontainer_down:
    @just _run docker compose -f .devcontainer/compose.yaml \
     --profile arch --profile debian --profile code down

alias dev := devcontainer_arch
# Open a shell in the Arch devcontainer
[group('dev')]
devcontainer_arch: load_arch
    @just _run docker compose -f .devcontainer/compose.yaml \
     --profile arch exec -it arch-container zsh

alias id := init_desktop
# Initialize a new desktop install setup
[group('initialize')]
init_desktop:
    @just pacman_update
    @just pacman_default_install
    @just stow_all_config
    @just enable_desktop_apps
    @just install_browser

alias is := init_server
# Initialize a new server install setup
[group('initialize')]
init_server:
    @just pacman_update
    @just pacman_cli_install
    @just pacman_dev_install
    @just pacman_docker_install
    @just stow_cli_config

alias u := pacman_update
# Update all pacman packages
[group('setup')]
pacman_update:
    @just _msg "Updating packages..."
    @just _run sudo pacman -Syu

alias p := pacman_default_install
# Install default pacman packages
[group('setup')]
pacman_default_install:
    @just pacman_cli_install
    @just pacman_dev_install
    @just pacman_docker_install
    @just pacman_desktop_install
    @just pacman_vm_install

# Sync files between directory
[group('data')]
_push_file src dest:
    @just _run sudo rsync -PHav --delete-after --delete-excluded --exclude={'.venv','node_modules','target','__pycache__','.svelte-kit'} "$src" "$dest"
# Sync files between directory
[group('data')]
_pull_file src dest:
    @just _run sudo rsync -PHav "$src" "$dest"

alias push := push_local_data
# Push local data to backup
[group('data')]
push_local_data:
    #!/bin/bash
    set -euo pipefail
    if [[ ! -d "$BACKUP_DIRECTORY" ]]; then
        just _error_msg "Backup directory does not exist: $BACKUP_DIRECTORY"
        exit 0
    fi
    just _msg "Pushing local data to backup: $BACKUP_DIRECTORY"
    just _push_file ~/Desktop   "$BACKUP_DIRECTORY"
    just _push_file ~/Downloads "$BACKUP_DIRECTORY"
    just _push_file ~/Documents "$BACKUP_DIRECTORY"
    just _push_file ~/lib       "$BACKUP_DIRECTORY"
    just _push_file ~/Music     "$BACKUP_DIRECTORY"
    just _push_file ~/Pictures  "$BACKUP_DIRECTORY"
    just _push_file ~/Projects  "$BACKUP_DIRECTORY"
    just _push_file ~/sh        "$BACKUP_DIRECTORY"
    just _push_file ~/Videos    "$BACKUP_DIRECTORY"
    just _push_file ~/.dotfiles "$BACKUP_DIRECTORY"
    just _push_file ~/.ssh      "$BACKUP_DIRECTORY"

alias pull := pull_backup_data
# Pull backup data to local
[group('data')]
pull_backup_data:
    #!/bin/bash
    set -euo pipefail
    if [[ ! -d "$BACKUP_DIRECTORY" ]]; then
        just _error_msg "Backup directory does not exist: $BACKUP_DIRECTORY"
        exit 0
    fi
    just _msg "Pulling backup data to local home directory"
    just _pull_file "$BACKUP_DIRECTORY/Desktop/"   ~/Desktop
    just _pull_file "$BACKUP_DIRECTORY/Downloads/" ~/Downloads
    just _pull_file "$BACKUP_DIRECTORY/Documents/" ~/Documents
    just _pull_file "$BACKUP_DIRECTORY/lib/"       ~/lib
    just _pull_file "$BACKUP_DIRECTORY/Music/"     ~/Music
    just _pull_file "$BACKUP_DIRECTORY/Pictures/"  ~/Pictures
    just _pull_file "$BACKUP_DIRECTORY/Projects/"  ~/Projects
    just _pull_file "$BACKUP_DIRECTORY/sh/"        ~/sh
    just _pull_file "$BACKUP_DIRECTORY/Videos/"    ~/Videos
    just _pull_file "$BACKUP_DIRECTORY/.dotfiles/" ~/.dotfiles
    just _pull_file "$BACKUP_DIRECTORY/.ssh/"      ~/.ssh

alias s := stow_all_config
# Stow all config files
[group('setup')]
stow_all_config:
    @just stow_cli_config
    @just stow_desktop_config

alias g := install_steam
# Add multilib to pacman and install Steam
[group('setup')]
install_steam:
    just _run sudo sed -i '/^# *\[multilib\]/{s/^# *//; n; s/^# *//}' /etc/pacman.conf
    just _run sudo pacman -Syu
    just _run sudo pacman -S --needed xwayland-satellite
    just _run sudo pacman -S --needed steam
    just _msg 'Run "sudo systemctl reboot" if this is the first time running this task'

alias a := install_aur_manager
# Install AUR Package manager
[group('setup')]
install_aur_manager:
    #!/bin/bash
    set -euo pipefail
    if command -v paru > /dev/null 2>&1 ]; then
        just _skip_msg "install_aur_manager" "paru already installed"
        exit 0
    fi
    just _run sudo pacman -S --needed base-devel
    if [[ ! -d paru ]]; then
        just _run git clone https://aur.archlinux.org/paru.git
    fi
    just _msg "Running cd paru && makepkg -si"
    cd paru && makepkg -si
    cd -
    just _msg "Should the AUR git repo be deleted (y = yes)"
    if [[ -d paru ]]; then
        rm -rf paru/.git
        rm -rI paru
    fi

alias b := install_browser
# Install web browser from AUR
[group('setup')]
install_browser: install_aur_manager
    @just _run paru -Sy --needed brave-bin

alias e := enable_desktop_apps
# Enable desktop application on startup
[group('setup')]
enable_desktop_apps:
    @just _run systemctl --user enable dms
    @just _run sudo systemctl enable ly@tty1.service

alias sc := stow_cli_config
# Stow CLI config files
[group('stow')]
stow_cli_config:
    @just _msg "Applying CLI environment config"
    @just _run mkdir -p ~/.config
    @just _run mkdir -p ~/.ssh
    @just _run stow --adopt \
        aliases \
        git \
        helix \
        lazygit \
        ssh \
        starship \
        zellij \
        zsh
    @just _run git restore .
    @just _run chsh -s /bin/zsh

alias sd := stow_desktop_config
# Stow desktop config files
[group('stow')]
stow_desktop_config:
    @just _run mkdir -p ~/.config
    @just _msg "Applying desktop environment config"
    @just _run stow --adopt \
        kitty \
        mpv \
        niri \
        quickshell \
        xdg
    @just _run git restore .

# Install CLI pacman packages
[group('pacman')]
pacman_cli_install:
    @just _msg "Installing CLI packages..."
    @just _run sudo pacman -S --needed \
        bat \
        btop \
        eza \
        fastfetch \
        fd \
        fzf \
        git \
        git-delta \
        helix \
        jq \
        lazydocker \
        lazygit \
        less \
        openssh \
        ripgrep \
        rsync \
        starship \
        stow \
        tree \
        ttf-hack-nerd \
        ufw \
        zellij \
        zoxide \
        zsh

# Install dev pacman
[group('pacman')]
pacman_dev_install:
    @just _msg "Installing dev packages..."
    @just _run sudo pacman -S --needed \
        dos2unix \
        ffmpeg \
        npm \
        python \
        rust

# Install docker pacman
[group('pacman')]
pacman_docker_install:
    @just _msg "Installing docker packages..."
    @just _run sudo pacman -S --needed \
        docker \
        docker-buildx \
        docker-compose
    @just _run sudo usermod -aG docker $USER

# Install desktop pacman
[group('pacman')]
pacman_desktop_install:
    @just _msg "Installing desktop packages..."
    @just _run sudo pacman -S --needed \
        adw-gtk-theme \
        base-devel \
        dgop \
        dms-shell \
        qt6ct \
        kitty \
        ly \
        matugen \
        mpv \
        nautilus \
        niri \
        noto-fonts \
        noto-fonts-cjk \
        noto-fonts-emoji \
        quickshell

# Install VM pacman
[group('pacman')]
pacman_vm_install:
    @just _msg "Installing VM packages..."
    @just _run sudo pacman -S --needed \
        virt-manager \
        qemu-full \
        libvirt \
        dnsmasq

alias d := docker_up
# Start Docker
[group('hypervisor')]
docker_up:
    @just _run sudo systemctl start docker.service
alias dd := docker_down
# Down Docker engine and reset interal ip tables
[group('hypervisor')]
docker_down:
    @just _run sudo systemctl stop docker.service docker.socket
    @just _run sudo nft flush ruleset

alias vms := setup_vm
# Setup base configuation to start using VM
[group('hypervisor')]
setup_vm:
    @just _run sudo systemctl start libvirtd.service
    @just _run sudo virsh net-autostart default
    @just _run sudo virsh net-list --all
    @just _run sudo usermod -aG libvirt $USER
    @just _run sudo systemctl stop \
     libvirtd.service \
     libvirtd.socket \
     libvirtd-ro.socket \
     libvirtd-admin.socket
alias vm := start_vm
# Start apps needed to use VM
[group('hypervisor')]
start_vm:
    @just _run sudo systemctl start libvirtd.service
    @just _run sudo virsh net-list --all
