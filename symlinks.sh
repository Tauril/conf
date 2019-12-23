#! /bin/zsh

# Root of the installation directory.
export ROOT=`dirname $0`

echo "Creating synbolic links of config files ..."
ln -s $ROOT/.oh-my-zsh $ROOT/.vim $ROOT/.gitconfig $ROOT/.vimrc $ROOT/.zshrc $HOME

# This needs to happen after creating the symlink of `.oh-my-zsh`.
ln -s $ROOT/custom.zsh-theme $HOME/.oh-my-zsh/themes/

cp -R $ROOT/.ssh $HOME
