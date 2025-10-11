#!/bin/bash

# Validate running in bash
if [ -z "$BASH_VERSION" ]; then
    echo "This script must be run in bash" >&2
    exit 1
fi

# Check for required dependencies
for cmd in curl git; do
    if ! command -v $cmd &> /dev/null; then
        echo "$cmd is required but not installed" >&2
        exit 1
    fi
done

# Ask for admin password upfront
sudo -v || { echo "Failed to get sudo privileges" >&2; exit 1; }

# Keep-alive: update existing `sudo` time stamp until script finishes
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Flags
set -e          # Global exit on error flag
set -o pipefail # Exit on pipe error
set -x          # Higher verbosity for easier debug

# Install developer tools if not already installed
if ! xcode-select -p &>/dev/null; then
    echo "Installing XCode Command Line Tools..."
    xcode-select --install || { echo "Failed to install XCode tools" >&2; exit 1; }
    # Wait for XCode CLI tools to install
    until xcode-select -p &>/dev/null; do
        sleep 5
    done
fi

# Accept XCode license
sudo xcodebuild -license accept || { echo "Failed to accept XCode license" >&2; exit 1; }

# Allow third party software
sudo spctl --master-disable || { echo "Failed to disable Gatekeeper" >&2; exit 1; }

# Install Homebrew
if ! command -v brew &>/dev/null; then
    echo "Installing Homebrew..."
    if [[ $(uname -m) == "arm64" ]]; then
        # M1/M2 Mac
        echo "Configuring for M-series chips..."
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || { echo "Failed to install Homebrew" >&2; exit 1; }
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        # Intel Mac
        echo "Installing for Intel based chips..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || { echo "Failed to install Homebrew" >&2; exit 1; }
    fi
fi

# Update and upgrade Homebrew
echo "Updating Homebrew..."
brew update || { echo "Failed to update Homebrew" >&2; exit 1; }
echo "Upgrading Homebrew packages..."
brew upgrade || { echo "Failed to upgrade Homebrew packages" >&2; exit 1; }

# Install Zsh and Oh My Zsh
if ! command -v zsh &>/dev/null; then
    echo "Installing Zsh..."
    brew install zsh || { echo "Failed to install Zsh" >&2; exit 1; }
fi

# Set Zsh as default shell
if [[ $SHELL != */zsh ]]; then
    echo "Setting Zsh as default shell..."
    chsh -s "$(which zsh)" || { echo "Failed to set Zsh as default shell" >&2; exit 1; }
fi

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended || { echo "Failed to install Oh My Zsh" >&2; exit 1; }
fi

# Install Powerline fonts
echo "Installing Powerline fonts..."
git clone https://github.com/powerline/fonts.git --depth=1 || { echo "Failed to clone Powerline fonts" >&2; exit 1; }
cd fonts
./install.sh || { echo "Failed to install Powerline fonts" >&2; exit 1; }
cd ..
rm -rf fonts

# Install SDKMAN
if [ ! -d "$HOME/.sdkman" ]; then
    echo "Installing SDKMAN..."
    curl -s "https://get.sdkman.io" | bash || { echo "Failed to install SDKMAN" >&2; exit 1; }
    source "$HOME/.sdkman/bin/sdkman-init.sh"
fi

# Check for Brewfile
if [ ! -f "Brewfile" ]; then
    echo "Brewfile not found in current directory" >&2
    exit 1
fi

# Install from Brewfile
echo "Installing packages from Brewfile..."
brew bundle || { echo "Failed to install packages from Brewfile" >&2; exit 1; }

# Cleanup
echo "Cleaning up Homebrew..."
brew cleanup || { echo "Failed to cleanup Homebrew" >&2; exit 1; }

echo "Installation completed successfully!"