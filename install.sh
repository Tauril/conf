#! /bin/bash

setopt extendedglob
setopt glob_dots

git submodule init
git submodule update

# Root of the installation directory.
export ROOT=$PWD

# Locally define $ZSH_CUSTOM as it is not yet defined when we execute the script.
export ZSH_CUSTOM=$ROOT/.oh-my-zsh/custom

echo "Installing dependencies ..."
sudo apt install vim xterm zsh graphviz compton feh build-essential curl htop \
  libcairo2-dev bc imagemagick libjpeg-turbo8-dev libpam0g-dev libev-dev      \
  libxcb-composite0-dev libxcb-image0-dev libxcb-randr0-dev libxcb-util-dev   \
  libxcb-xinerama0-dev libxcb-xinerama0-dev libxcb-xkb-dev libxcb-xrm-dev     \
  libxkbcommon-x11-dev

echo "Set up zsh as default shell.Log in and out to apply changes."
chsh -s /bin/zsh

echo "Set up xterm as default term"
sudo update-alternatives --config x-terminal-emulator

echo "Installing fonts"
cd .fonts && ./install.sh && cd -

echo "Set lock screen."
sudo ./betterlockscreen.sh
betterlockscreen -u $ROOT/wallpapers/dbz.jpg # -r 1920x1200

cp custom.zsh-theme $ZSH_CUSTOM/themes/

echo "Cloning zsh-256color ..."
git clone https://github.com/chrissicool/zsh-256color $ZSH_CUSTOM/plugins/zsh-256color

echo "Creating synbolic links of config files ..."
ln -s .oh-my-zsh .vim .gitconfig .fonts .vimrc .Xdefaults .zshrc $HOME
ln -s compton.conf $HOME/.config

echo "Installing thefuck ..."
sudo apt install python3-dev python3-pip python3-setuptools
sudo pip3 install thefuck

# Apply colorscheme.
xrdb .Xdefaults

# Create keybind for the new lock screen.
# First remove the old keybind of $mod+l
sed -i ':a;N;$!ba;s/bindsym \$mod+l[^\n]*\n//' $HOME/.config/i3/conf
# Then append the new bind
echo "bindsym $mod+l exec --no-startup-id betterlockscreen -l dim" >> $HOME/.config/i3/config

# Load custom colors/fonts
echo "exec --no-startup-id xrdb -load $HOME/.Xdefaults" >> $HOME/.config/i3/config

# Set background
echo "exec --no-startup-id feh --bg-fill $ROOT/wallpapers/dbz.jpg" >> $HOME/.config/i3/config

# Set transparency
# echo "exec --no-startup-id compton -b --config $HOME/.config/compton.conf --vsync opengl" >> $HOME/.config/i3/config

# Fixes pixels display error when splitting horizontally
echo "new_window pixel" >> $HOME/.config/i3/config

echo "Installation complete. You can now close this terminal and open a new one to start working."
