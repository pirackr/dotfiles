#!/usr/bin/env bash
_install_packages() {
    # System
    sudo pacman -S xorg xorg-xinit i3 sudo wget curl
    # Dev tools
    sudo pacman -S base-devel git vim rxvt-unicode emacs zsh httpie hub progress shellcheck ansible vagrant net-tools postgresql postgis tmux redis firefox stack
    # Application
    sudo pacman -S cmus chromium zathura zathura-djvu zathura-pdf-mupdf scrot mirage sxiv virtualbox mps-youtube mplayer youtube-dl fcitx fcitx-qt4 fcitx-qt5 fcitx-gtk2 fcitx-gtk3 fcitx-unikey fcitx-configtool nitrogen dmenu openssh ttf-liberation powerline-fonts
}

_create_directories() {
    mkdir -p ~/dotfiles
}

_setup_urxvt() {
    ln -s ~/dotfiles/urxvt/Xdefaults ~/.Xdefaults
    ln -s ~/dotfiles/urxvt/Xresources ~/.Xresources
}

_setup_antigen() {
    git clone https://github.com/zsh-users/antigen.git ~/dotfiles/zsh/antigen
    ln -s ~/dotfiles/zsh/zshrc ~/.zshrc
    ln -s ~/dotfiles/zsh/zprofile ~/.zprofile
}

_setup_python() {
    git clone https://github.com/yyuu/pyenv.git ~/.pyenv
    git clone https://github.com/yyuu/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv
}

_setup_emacs() {
    curl -L https://git.io/epre | sh
    rm -rf ~/.emacs.d/personal
    ln -s ~/dotfiles/emacs/personal ~/.emacs.d/personal
}

_install_liberation_mono_powerline() {
    mkdir -p ~/.fonts
    wget https://github.com/powerline/fonts/raw/master/LiberationMono/Literation%20Mono%20Powerline.ttf -O ~/.fonts/Liberation\ Mono\ Powerline.ttf
    wget https://github.com/powerline/fonts/raw/master/LiberationMono/Literation%20Mono%20Powerline%20Bold.ttf -O ~/.fonts/Liberation\ Mono\ Powerline\ Bold.ttf
    wget https://github.com/powerline/fonts/raw/master/LiberationMono/Literation%20Mono%20Powerline%20Italic.ttf -O ~/.fonts/Liberation\ Mono\ Powerline\ Italic.ttf
    wget https://github.com/powerline/fonts/raw/master/LiberationMono/Literation%20Mono%20Powerline%20Bold%20Italic.ttf -O ~/.fonts/Liberation\ Mono\ Powerline\ Bold\ Italic.ttf
    fc-cache -vf ~/.fonts    
}

_setup_nvm() {
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.1/install.sh | bash
}

_run() {
    _install_needed_packages
    _create_directories
    _setup_urxvt
    _setup_antigen
    _setup_emacs
    _setup_python
    _setup_nvm
}

_install_liberation_mono_powerline
