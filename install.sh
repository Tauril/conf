#! /bin/bash

setopt extendedglob
setopt glob_dots

git submodule init
git submodule update

# Root of the installation directory.
export ROOT=$PWD

# Locally define $ZSH_CUSTOM as it is not yet defined when we execute the script.
export ZSH_CUSTOM=$ROOT/.oh-my-zsh/custom

echo "Set up zsh as default shell.Log in and out to apply changes."
#chsh -s /bin/zsh

echo "Set up xterm as default term"
#sudo update-alternatives --config x-terminal-emulator

ln -s $ROOT/custom.zsh-theme $ZSH_CUSTOM/themes/

echo "Cloning zsh-256color ..."
#git clone https://github.com/chrissicool/zsh-256color $ZSH_CUSTOM/plugins/zsh-256color

echo "Creating synbolic links of config files ..."
ln -s $ROOT/.oh-my-zsh $ROOT/.vim $ROOT/.gitconfig $ROOT/.vimrc $ROOT/.zshrc $HOME

echo "Applying vim patch"
cd $ROOT/.vim/bundle/vim-colors-solarized && git apply $ROOT/0001-update-saturated-colors.patch && cd -

echo "Installation complete. You can now close this terminal and open a new one to start working."
