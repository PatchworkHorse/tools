#!/bin/bash

# Need to run as sudo
if [ "$EUID" -eq 0 ]
  then echo "Please do not run as root"
  exit
fi

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
me=$(whoami)
echo >> /home/$me/.bashrc
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/$me/.bashrc
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Install oh-my-posh
brew install jandedobbeleer/oh-my-posh/oh-my-posh

# Install unzip (if not already installed)
if ! command -v unzip &> /dev/null
then
    echo "unzip could not be found, installing..."
    brew install unzip
fi

# Download and unzip themes
mkdir -p $me/.poshthemes
wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip -O $me/.poshthemes/themes.zip
unzip -o ~/.poshthemes/themes.zip -d $me/poshthemes

# Install oh-my-posh
brew install jandedobbeleer/oh-my-posh/oh-my-posh

# Get our bashrc extension, source in ~/.bashrc
wget https://raw.githubusercontent.com/PatchworkHorse/tools/refs/heads/main/PatchworkEnvironment/.patchwork.bashrc -O ~/.patchwork.bashrc
echo >> ~/.bashrc
echo 'source ~/.patchwork.bashrc' >> ~/.bashrc

# Reload bashrc
. ~/.bashrc
