# Ask for admin password upfront
sudo -v

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

# Install Cask
echo "Checking brew cask..."
brew install caskroom/cask/brew-cask &>/dev/null
brew upgrade brew-cask &>/dev/null

which -s java || brew cask install java
which -s git || brew install git
which -s sbt || brew install sbt
which -s scala || brew install scala
which -s ammonite-repl || brew install ammonite-repl
which -s node || brew install node
which -s mysql || brew install mysql
which -s wget || brew install wget
which -s ack || brew install ack
which -s llvm || brew install llvm

# Generic softwares
brew cask install 1password
brew cask install adobe-acrobat-reader
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
brew cask install microsoft-office
brew cask install omnidisksweeper
brew cask install quik
brew cask install scroll-reverser
brew cask install skype
brew cask install spotify
brew cask install vlc
brew cask install whatsapp
brew cask install zoomus


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
