#!/bin/bash

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install oh-my-posh
brew install jandedobbeleer/oh-my-posh/oh-my-posh

# Download and unzip themes
mkdir -p ~/.poshthemes
wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip -O ~/.poshthemes/themes.zip
unzip ~/.poshthemes/themes.zip -d ~/.poshthemes

# Get our bashrc extension, append to ~/.bashrc
echo "source ~/.patchwork.bashrc" >> ~/.bashrc

# Reload bashrc
. ~/.bashrc
