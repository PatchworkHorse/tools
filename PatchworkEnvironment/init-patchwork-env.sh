#!/bin/bash

# If this is a Debian system, offer to install build-essential since it's faster than building from source
# if [ -f /etc/debian_version ]; then
#   echo "This is a Debian-based system. Would you like to install build-essential to speed up the installation of some packages?"
#   echo "This will require sudo access."
#   read -p "(y/n): " -r response
#   if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
#     sudo apt-get update
#     sudo apt-get install -y build-essential golang-go
#   fi
# fi

# Todo: Check if Homebrew is installed and skip if it is

# Install Homebrew
/bin/bash -c "mkdir ~/homebrew && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C ~/homebrew"
export PATH=~/homebrew/bin:$PATH

# Install oh-my-posh
brew install jandedobbeleer/oh-my-posh/oh-my-s

# Download and unzip themes
mkdir -p $me/.poshthemes
wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip -O $me/.poshthemes/themes.zip
unzip -o ~/.poshthemes/themes.zip -d $me/poshthemes

# Install oh-my-posh
brew install jandedobbeleer/oh-my-posh/oh-my-posh

# Get our bashrc extension, source in ~/.bashrc
wget https://raw.githubusercontent.com/PatchworkHorse/tools/refs/heads/main/PatchworkEnvironment/.patchwork.bashrc -O ~/.patchwork.bashrc

if ! grep -q 'source ~/.patchwork.bashrc' ~/.bashrc; then
  echo 'source ~/.patchwork.bashrc' >> ~/.bashrc
fi

# Reload bashrc
. ~/.bashrc
