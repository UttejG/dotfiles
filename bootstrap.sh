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
brew tap homebrew/dupes &>/dev/null
brew tap homebrew/boneyard &>/dev/null
brew install homebrew/dupes/grep &>/dev/null

#Upgrade already installed formulae
brew upgrade

# Install Zsh
curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
echo "Installing fonts for Zsh..."
git clone https://github.com/powerline/fonts.git
./fonts/install.sh
rm -rf fonts

# Install
echo "Checking brew..."
brew installroom/cask/brew-cask &>/dev/null
brew upgrade brew-cask &>/dev/null

which -s java || brew install java
which -s jenv || brew install jenv

which -s sbt || brew install sbt
which -s scala || brew install scala
which -s ammonite-repl || brew install ammonite-repl

which -s node || brew install node
which -s nvm || brew install nvm

which -s git || brew install git
which -s mysql || brew install mysql
which -s wget || brew install wget
which -s ack || brew install ack
which -s llvm || brew install llvm

# Generic software
brew install 1password
brew install adobe-acrobat-reader
brew install alfred
brew install anki
brew install avast-security
brew install bettertouchtool
brew install caffeine
brew install coconutbattery
brew install dropbox
brew install evernote
brew install firefox
brew install flashlighttool
brew install garmin-express
brew install google-chrome
brew install kindle
brew install microsoft-office
brew install omnidisksweeper
brew install quik
brew install scroll-reverser
brew install skype
brew install spotify
brew install vlc
brew install whatsapp
brew install zoomus

# Mac App Store Installs
brew install mas
mas "Annotate", id: 918207447
mas "Caffeine", id: 411246225                       # 
mas "feedly", id: 865500966 
mas "Monosnap", id: 540348655
mas "PhotoScape X", id: 929507092
mas "Spark", id: 1176895641                         # Good e-Mail client
mas "TweetDeck", id: 485812721
mas "Twitter", id:409789998
mas "Who's On My WiFi", id: 909760813               # Easily search devices on wifi and store MAC addresses


# Security Tools
brew install keybase
brew install torbrowser

# Developer tools
brew install diffmerge
brew install docker
brew install gitter
brew install github
brew install iterm2
brew install intellij-idea
brew install postman
brew install sequel-pro
brew install slack
brew install sourcetree
brew install visual-studio-code
brew install virtualbox

# Cleanup
brew cleanup
