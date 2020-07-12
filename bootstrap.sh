#!/bin/bash

# Ask for admin password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Intall developer tools if not already installed
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

# Install Cask
echo "Checking brew cask..."
brew install caskroom/cask/brew-cask &>/dev/null
brew upgrade brew-cask &>/dev/null

which -s java || brew cask install java
which -s jenv || brew cask install jenv

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

# Generic softwares
brew cask install 1password
brew cask install adobe-acrobat-reader
brew cask install alfred
brew cask install anki
brew cask install avast-security
brew cask install bettertouchtool
brew cask install caffeine
brew cask install coconutbattery
brew cask install dropbox
brew cask install evernote
brew cask install firefox
brew cask install flashlight
brew cask install garmin-express
brew cask install google-chrome
brew cask install kindle
brew cask install microsoft-office
brew cask install omnidisksweeper
brew cask install quik
brew cask install scroll-reverser
brew cask install skype
brew cask install spotify
brew cask install vlc
brew cask install whatsapp
brew cask install zoomus

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
brew cask install gpgtools
brew install keybase
brew cask install torbrowser

# Developer tools
brew cask install diffmerge
brew cask install docker
brew cask install gitter
brew cask install github-desktop
brew cask install iterm2
brew cask install intellij-idea
brew cask install postman
brew cask install sequel-pro
brew cask install slack
brew cask install sourcetree
brew cask install visual-studio-code
brew cask install virtualbox

# Cleanup
brew cleanup
