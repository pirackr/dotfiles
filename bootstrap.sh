#!/usr/bin/env bash
_install_packages() {
    # System
    sudo pacman -S --no-confirm base-devel git vim xorg xorg-xinit i3 sudo wget curl urxvt
    # Dev tools
    sudo pacman -S --no-confirm emacs zsh httpie hub progress shellcheck ansible vagrant net-tools postgresql posgis tmux redis firefox stack
    # Application
    sudo pacman -S --no-confirm cmus chromium zathura zathura-djvu zathura-pdf-mupdf scrot mirage sxiv virtualbox mps-youtube mplayer youtube-dl
}

_setup_urxvt() {
    ln -s ~/dotfiles/urxvt/Xdefaults ~/.Xdefaults
    ln -s ~/dotfiles/urxvt/Xresources ~/.Xresources
}

_create_directories() {
    mkdir -p ~/dotfiles
}

_setup_antigen() {
    git clone https://github.com/zsh-users/antigen.git ~/dotfiles/
    ln -s ~/dotfiles/zsh/zshrc ~/.zshrc
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

_setup_nvm() {
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.1/install.sh | bash
}

_run() {
    _install_needed_packages
    _create_directories
    _setup_antigen
    _setup_emacs
    _setup_python
    _setup_nvm
}

_setup_urxvt
