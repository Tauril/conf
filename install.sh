#! /bin/zsh

setopt extendedglob
setopt glob_dots

git submodule init
git submodule update

cp robbyrussell.zsh-theme .oh-my-zsh/themes/
cp .oh-my-zsh/templates/zshrc.zsh-template .zshrc
echo "setxkbmap us -option 'caps:swapescape' -variant altgr-intl" >> .zshrc
echo "setxkbmap fr" >> .zshrc
echo "xrdb -load .Xdefaults" >> .zshrc
echo "source .xinitrc" >> .zshrc
echo "xset r rate 300 50" >> .zshrc
echo "alias sshfencepost=\"ssh tauril@fencepost.gnu.org\"" >> .zshrc
cd $HOME
echo $OLDPWD/*~*.git~*.gitmodules~*install.sh~*zsh-theme*~*.swp
ln -s  $OLDPWD/*~*.git~*.gitmodules~*install.sh~*zsh-theme*~*.swp .

xrdb ~/.Xdefaults

echo "exec --no-startup-id feh --bg-scale $PWD/cattastic.jpg" \
>> $HOME/.config/i3/config
