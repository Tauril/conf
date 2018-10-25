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

cp robbyrussell-custom.zsh-theme .oh-my-zsh/themes/
cp .oh-my-zsh/templates/zshrc.zsh-template .zshrc
#echo "setxkbmap us -option 'caps:swapescape' -variant altgr-intl" >> .zshrc
echo "setxkbmap fr -option 'caps:swapescape'" >> .zshrc
echo "xset r rate 300 50" >> .zshrc
echo "alias sshfencepost=\"ssh tauril@fencepost.gnu.org\"" >> .zshrc
cd $HOME
echo $OLDPWD/*~*.git~*.gitmodules~*install.sh~*zsh-theme*~*.swp~*.jpg~*compton.conf
ln -s  $OLDPWD/*~*.git~*.gitmodules~*install.sh~*zsh-theme*~*.swp~*.jpg~*compton.conf .
cd $OLDPWD
cd $HOME/.config && ln -s $OLDPWD/compton.conf .

xrdb ~/.Xdefaults

echo "exec --no-startup-id xrdb -load $HOME/.Xdefaults" >> $PWD/i3/config
echo "exec --no-startup-id feh --bg-fill $OLDPWD/dbz.jpg" >> $PWD/i3/config
echo "exec --no-startup-id compton -b --config $OLDPWD/compton.conf --vsync opengl" >> $PWD/i3/config
# Fixes pixels display error when splitting horizontally
echo "new_window pixel" >> $PWD/i3/config
