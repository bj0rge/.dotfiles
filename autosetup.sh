#!/bin/bash

# Function to check if a command exists
command_exists() {
  command -v "$1" &> /dev/null
}

# Function to handle errors
handle_error() {
  echo "Error occurred. Exiting script."
  exit 1
}

# Ensure necessary commands are available
install_dependencies() {
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux-specific commands
    if ! command_exists curl; then
      echo "Installing curl..."
      sudo apt-get update && sudo apt-get install -y curl || handle_error
      echo "curl installed successfully."
    fi
    if ! command_exists git; then
      echo "Installing git..."
      sudo apt-get update && sudo apt-get install -y git || handle_error
      echo "git installed successfully."
    fi
    if ! command_exists zsh; then
      echo "Installing zsh..."
      sudo apt-get update && sudo apt-get install -y zsh || handle_error
      echo "zsh installed successfully."
    fi
    if ! command_exists vim; then
      echo "Installing vim..."
      sudo apt-get update && sudo apt-get install -y vim || handle_error
      echo "vim installed successfully."
    fi
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS-specific commands
    if ! command_exists brew; then
      echo "Installing Homebrew..."
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || handle_error
      echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
      eval "$(/opt/homebrew/bin/brew shellenv)"
      echo "Homebrew installed successfully."
    fi
    if ! command_exists curl; then
      echo "Installing curl via Homebrew..."
      brew install curl || handle_error
      echo "curl installed successfully."
    fi
    if ! command_exists git; then
      echo "Installing git via Homebrew..."
      brew install git || handle_error
      echo "git installed successfully."
    fi
    if ! command_exists zsh; then
      echo "Installing zsh via Homebrew..."
      brew install zsh || handle_error
      echo "zsh installed successfully."
    fi
    if ! command_exists vim; then
      echo "Installing vim via Homebrew..."
      brew install vim || handle_error
      echo "vim installed successfully."
    fi
    # Add Homebrew to PATH for macOS
    echo "Adding Homebrew to PATH..."
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
    source ~/.zshrc || handle_error
    echo "Homebrew added to PATH successfully."
  else
    echo "Unsupported operating system"
    exit 1
  fi
}

# Execute the commands
install_zsh() {
  if ! command_exists zsh; then
    echo "Installing Oh My Zsh..."
    curl -L http://install.ohmyz.sh | sh || handle_error
    echo "Oh My Zsh installed successfully."
  fi
}

# Rename ~/.zshrc to ~/.zshrc.bak
backup_zshrc() {
  echo "Backing up existing ~/.zshrc..."
  mv ~/.zshrc ~/.zshrc.bak || handle_error
  echo "~/.zshrc backed up successfully."
}

# Copy ./zsh/.zshrc to ~
copy_custom_zshrc() {
  echo "Copying new ~/.zshrc..."
  cp ./zsh/.zshrc ~ || handle_error
  echo "New ~/.zshrc copied successfully."
}

# Modify ~/.zshrc to replace DEFAULT_USER
update_default_user() {
  DEFAULT_USER=$(whoami)
  echo "Updating DEFAULT_USER in ~/.zshrc..."
  if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' "s/DEFAULT_USER=\"bjorge\"/DEFAULT_USER=\"$DEFAULT_USER\"/g" ~/.zshrc || handle_error
  else
    sed -i "s/DEFAULT_USER=\"bjorge\"/DEFAULT_USER=\"$DEFAULT_USER\"/g" ~/.zshrc || handle_error
  fi
  echo "DEFAULT_USER updated successfully."
}

# Modify ~/.zshrc to replace /home/bjorge with /Users/$(whoami)
update_home_folder() {
  echo "Updating home directory path in ~/.zshrc..."
  if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' "s|/home/bjorge|/Users/$DEFAULT_USER|g" ~/.zshrc || handle_error
  else
    sed -i "s|/home/bjorge|/Users/$DEFAULT_USER|g" ~/.zshrc || handle_error
  fi
  echo "Home directory path updated successfully."
}

# Download agnoster-nanof.zsh-theme
use_custom_agnoster_theme() {
  echo "Downloading agnoster-nanof.zsh-theme..."
  curl -o ~/.oh-my-zsh/themes/agnoster-nanof.zsh-theme https://raw.githubusercontent.com/fsegouin/oh-my-zsh-agnoster-mod-theme/refs/heads/master/agnoster-nanof.zsh-theme || handle_error
  echo "agnoster-nanof.zsh-theme downloaded successfully."
}

# Clone zsh-syntax-highlighting plugin
use_zsh_syntax_highlighting() {
  echo "Cloning zsh-syntax-highlighting plugin..."
  cd ~/.oh-my-zsh/custom/plugins || handle_error
  git clone git@github.com:zsh-users/zsh-syntax-highlighting.git || handle_error
  echo "zsh-syntax-highlighting plugin cloned successfully."
}

# Install spf13-vim3
install_spf13_vim3() {
  echo "Installing spf13-vim3..."
  curl http://j.mp/spf13-vim3 -L -o - | sh || handle_error
  echo "spf13-vim3 installed successfully."
}

# Source ~/.zshrc
source_zshrc() {
  echo "Sourcing ~/.zshrc..."
  source ~/.zshrc || handle_error
  echo "~/.zshrc sourced successfully."
}

install_dependencies
install_zsh
backup_zshrc
copy_custom_zshrc
update_default_user
update_home_folder
use_custom_agnoster_theme
use_zsh_syntax_highlighting
install_spf13_vim3
source_zshrc

echo "Setup completed successfully."