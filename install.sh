#! /bin/zsh

setopt extendedglob
setopt glob_dots

git submodule init
git submodule update

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

echo "Set lock screen."
sudo ./betterlockscreen.sh
betterlockscreen -u $PWD/dbz.png # -r 1920x1200

cp robbyrussell-custom.zsh-theme .oh-my-zsh/themes/
cp .oh-my-zsh/templates/zshrc.zsh-template .zshrc
#echo "setxkbmap us -option 'caps:swapescape' -variant altgr-intl" >> .zshrc
echo "setxkbmap fr -option 'caps:swapescape'" >> .zshrc
echo "xset r rate 300 50" >> .zshrc
echo "alias sshfencepost=\"ssh tauril@fencepost.gnu.org\"" >> .zshrc
echo "bindkey \^U backward-kill-line" >> .zshrc
echo "finish() {" >> .zshrc
echo "spd-say \"finished $1\"" >> .zshrc
echo "}" >> .zshrc
cd $HOME
echo $OLDPWD/*~*.git~*.gitmodules~*install.sh~*zsh-theme*~*.swp~*.jpg~*compton.conf
ln -s  $OLDPWD/*~*.git~*.gitmodules~*install.sh~*zsh-theme*~*.swp~*.jpg~*compton.conf .
cd $OLDPWD
cd $HOME/.config && ln -s $OLDPWD/compton.conf .

xrdb ~/.Xdefaults

# Create keybind for the new lock screen
echo "bindsym $mod+Shift+x exec --no-startup-id betterlockscreen -l dim" >> $PWD/i3/config
# Load custom colors/fonts
echo "exec --no-startup-id xrdb -load $HOME/.Xdefaults" >> $PWD/i3/config
# Set background
echo "exec --no-startup-id feh --bg-fill $OLDPWD/dbz.jpg" >> $PWD/i3/config
# Set transparency
echo "exec --no-startup-id compton -b --config $OLDPWD/compton.conf --vsync opengl" >> $PWD/i3/config
# Fixes pixels display error when splitting horizontally
echo "new_window pixel" >> $PWD/i3/config
