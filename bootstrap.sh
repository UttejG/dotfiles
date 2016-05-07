# Ask for admin password upfront
sudo -v

which -s brew
if [[ $? != 0 ]] ; then
  echo "Installing brew..."
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update brew
echo "Updating brew..."
brew update &>/dev/null
brew tap homebrew/dupes &>/dev/null
brew tap homebrew/boneyard &>/dev/null
brew install homebrew/dupes/grep &>/dev/null

#Upgrade already installed formulae
brew upgrade --all

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
which -s node || brew install node
which -s mysql || brew install mysql
which -s wget || brew install wget
which -s ack || brew install ack

# Generic softwares
brew cask install caffeine
brew cask install scroll-reverser
brew cask install avast
brew cask install evernote
brew cask install dropbox
brew cask install nylas-n1
brew cask install firefox
brew cask install google-chrome
brew cask install vlc
brew cask install spotify
brew cask install gopro
brew cask install gopro-studio
brew cask install flashlight
brew cask install skype
brew cask install garmin-express

# Security Tools
brew cask install torbrowser
brew cask install gpgtools

# Developer tools
brew cask install intellij-idea
brew cask install iterm2
brew cask install atom
brew cask install sequel-pro
brew cask install visual-studio-code
brew cask install github-desktop
brew cask install sourcetree
brew cask install gitter
brew cask install slack
brew cask install virtualbox
brew cask install diffmerge


#Install atom plugin
apm install autocomplete-paths
apm install editorconfig
apm install enhanced-tabs
apm install file-icons
apm install git-go
apm install git-history
apm install git-log
apm install git-plus
apm install highlight-line
apm install highlight-selected
apm install language-scala
apm install linter
apm install linter-eslint
apm install merge-conflicts
apm install minimap
#apm install minimap-color-highlight
apm install minimap-git-diff
apm install minimap-selection
apm install open-recent
apm install pigments
apm install project-manager
apm install react
apm install regex-railroad-diagram
apm install sort-lines
apm install sublime-style-column-selection

# Cleanup
brew cleanup
