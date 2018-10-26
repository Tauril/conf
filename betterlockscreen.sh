#/bin/bash

# Bash installation script for installing 'https://github.com/pavanjadhaw/betterlockscreen' in one go.
# Run this script as root

# Installation candidate details
install_candidate="betterlockscreen";
vendor="GitHub/pavanjadhaw";

# Install dependencies
printf -- "----------------------------------------------------------------------------------------------------";
printf "\n Installing dependencies. May take a few minutes.\n";
printf -- "----------------------------------------------------------------------------------------------------\n";

## Install i3lock-color dependency
git clone https://github.com/PandorasFox/i3lock-color && cd i3lock-color;
autoreconf -i; ./configure;
make; sudo checkinstall --pkgname=i3lock-color --pkgversion=1 -y;
cd .. && sudo rm -r i3lock-color;

printf -- "\n----------------------------------------------------------------------------------------------------";
printf "\n Dependencies installed! Proceeding ahead with the script.\n";
printf -- "----------------------------------------------------------------------------------------------------\n";

# Fetch the script and remove it after copying
if [[ -f /usr/bin/betterlockscreen ]]; then
    sudo rm /usr/bin/betterlockscreen;
fi
curl -o script https://raw.githubusercontent.com/pavanjadhaw/betterlockscreen/master/betterlockscreen;
sudo cp script /usr/bin/betterlockscreen;
sudo chmod +x /usr/bin/betterlockscreen;
rm script;

printf -- "\n----------------------------------------------------------------------------------------------------";
printf "\n Installation complete!";
printf -- "\n----------------------------------------------------------------------------------------------------";
