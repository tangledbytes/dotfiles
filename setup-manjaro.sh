#!/bin/bash

# This script is for setting up manjaro linux after its installation
# This script also assumes that I have setup manjaro using Manjaro architect edition and have ZSH has
# default shell

# Credit: https://github.com/ppo/bash-colors
c() { echo "$1" | sed -E "s/(^|[^-_])([krgybmcw])/\1-\2/;s/(^$|0)/!0¡/;s/([BUFNL])/!\1¡/g;s/([-_])([krgybmcw])/!\1\2¡/g;y/BUFN-_krgybmcw/14573401234567/;s/L/22/;s/!/\\\033[/g;s/¡/m/g"; }

# Logs the argument
log ()
{
    echo -e "$(c 0g)[CPP RUNNER]:$(c) $(c 0gL)$@$(c)"
}

# Log warning
warn()
{
    echo -e "$(c 0y)[CPP RUNNER]:$(c) $(c 0yL)$@$(c)"
}

# Log error
error()
{
    echo -e "$(c 0r)[CPP RUNNER]:$(c) $(c 0rL)$@$(c)"
}

# Parses the arguments passed
check_argument()
{
    for i in "$@"
    do
        VALUE=$(echo $i | awk -F= '{print $2}')
        case "$i" in
            -f| --full) full=0
            ;;
            --setup-kube) setup_kube=0
            ;;
            --setup-kde) setup_kde=0
            ;;
            --setup-basic) setup_basic=0
            ;;
            -h| --help) help
            ;;
        esac
    done
}

help() {
    echo "This script is for setting up manjaro linux after its installation"
    echo "This script also assumes that I have setup manjaro using Manjaro architect edition and have ZSH has default shell"
    echo ""
    echo "USAGE: ./setup-manjaro [flags]"
    echo ""
    echo "Flags:"
    echo "-h, --help            Will Print help for the script"
    echo "-f, --full            Full Will perform a full setup"
    echo "  , --setup-kde       Will setup kde config on the system"
    echo "  , --setup-kube      Will setup kubernetes on the system"
    echo "  , --setup-basic     Will setup the basic packages on the system"
    
    exit 0
}

function setupRequired() {
    log "Starting general setup..."

    # Place the dotfiles in their place
    cp -r ./.conky ./.zsh-plugins ./bin ./.zshrc ~/
    cp -r ./nvim ~/.config/nvim

    # ============ SETUP PACKAGES ============
    # Not adding --no-confirm to pacman for several reasons

    # Update the database 
    sudo pacman -Su

    # Install go
    sudo pacman -Sy go

    # Install kvantum manager
    sudo pacman -Sy kvantum-qt5

    # Install neovim
    sudo pacman -Sy neovim

    # Install conky
    sudo pacman -Sy conky

    # Install and setup docker
    sudo pacman -Sy docker docker-compose
    sudo usermod -aG docker $USER
    sudo systemctl start docker
    sudo systemctl enable docker

    ## AUR builds and installs 
    # Install fonts
    pamac build ttf-ms-fonts
    pamac build ttf-meslo-nerd-font-powerlevel10k
    pamac build otf-san-francisco
    pamac build nerd-fonts-fira-code

    # Install vscode
    pamac build visual-studio-code-bin
    
    # Install google-chrome
    pamac build google-chrome

    # Install Slack
    pamac build slack-desktop

    # Install Mailspring
    pamac build mailspring

    # Install spotify
    pamac build spotify
}

function setupKube() {
    log "Setting up kubernetes..."
    sudo pacman -Sy libvirt qemu ebtables dnsmasq
    sudo usermod -aG libvertd $USER
    
    sudo systemctl start libvirtd.service
    sudo systemctl enable libvirtd.service
    
    sudo systemctl start virtlogd.service
    sudo systemctl enable virtlogd.service

    sudo pacman -Sy docker-machine

    pamac build docker-machine-driver-kvm2
    
    sudo pacman -Syu minikube kubectl
    log "Completed installation..."
}

function setupKDE() {
    log "TODO"
}


# GLOBAL variables
setup_full=1
setup_kube=1
setup_basic=1
setup_kde=1

# ====================== EXECUTION ==========================
check_argument "$@"

if [ $setup_kube -eq 0 ]; then
    warn "Setting up kubernetes only"
    setupKube
    exit 0
if

if [ $setup_kube -eq 0 ]; then
    warn "Setting up KDE only"
    setupkde
    exit 0
if

if [ $setup_basic -eq 0 ]; then
    warn "Setting up basic only"
    setupRequired
    exit 0
if

if [ $setup_full -eq 0 ]; then
    setupRequired
    setupkde
    setupKube
    exit 0
if