#!/bin/bash

# Ask for admin password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Install developer tools if not already installed
xcode-select -p
if [ $? -eq 0 ]; then
    echo "Found XCode."
else
    echo "Installing XCode..."
    xcode-select --install
fi

# Since XCode was installed, accept license agreement
sudo xcodebuild -license

# Allow third party software
sudo spctl --master-disable

# Flags
set -e          # Global exit on error flag
set -o pipefail # Exit on pipe error
set -x          # Higher verbosity for easier debug

which -s brew
if [[ $? != 0 ]] ; then
  echo "Installing brew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

# Update brew
echo "Updating brew..."
brew update &>/dev/null

# Upgrade already installed formulae
echo "Upgrade already existing formulae..."
brew upgrade

# Install Zsh
curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
echo "Installing fonts for Zsh..."
git clone https://github.com/powerline/fonts.git
./fonts/install.sh
rm -rf fonts

# Install using Brewfile
brew bundle

# Cleanup
brew cleanup
