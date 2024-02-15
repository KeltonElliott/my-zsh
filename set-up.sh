#!/bin/zsh

# Exit immediately if a command exits with a non-zero status.
set -e

# Determine the directory where this script is located
GITPATH="$(dirname "$(realpath "$0")")"

# Function to display error messages in red
echo_error() {
  echo -e "\033[31mERROR: $1\033[0m"
}

# Function to prompt user to proceed with execution
prompt_for_confirmation() {
  echo "This script will do the following:"
  echo "- Install Homebrew (if not already installed)"
  echo "- Install the following packages using Homebrew:"
  echo "  - Starship"
  echo "  - Zsh syntax highlighting"
  echo "  - Autojump"
  echo "  - Zsh autosuggestions"
  echo "  - Git"
  echo "  - Visual Studio Code"
  echo "- Create the following directories in your home folder:"
  echo "  - .config"
  echo "  - github"
  echo "  - code"
  echo "- Download and install the Cascadia Code Nerd Font"
  echo "- Configure Zsh enhancements and the Starship prompt"
  echo "Do you want to continue? (y/n)"
  
  read answer
  if [[ "$answer" != "y" ]]; then
    echo_error "Exiting script."
    exit 1
  fi
}

install_deps() {
  # Check for Homebrew, install if we don't have it
  if test ! $(which brew); then
    echo "Installing Homebrew..."
    /bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || {
      echo_error "Error installing Homebrew. Please check your internet connection and permissions."
      exit 1
    }
  fi

  # Update Homebrew and upgrade any already-installed formulae
  echo "Updating and upgrading Homebrew packages..."
  brew update && brew upgrade || {
    echo_error "Error updating/upgrading Homebrew packages."
    exit 1
  }

  # Install dependencies
  for package in starship zsh-syntax-highlighting autojump zsh-autosuggestions git; do
    echo "Installing $package..."
    brew install $package || {
      echo_error "Error installing $package."
      exit 1
    }
  done

  # Install Visual Studio Code
  echo "Installing Visual Studio Code..."
  brew install --cask visual-studio-code || {
    echo_error "Error installing Visual Studio Code."
    exit 1
  }
}

create_dirs() {
  # Declare an array of directories to be created, now including ~/.config explicitly
  declare -a dirs=("$HOME/.config" "$HOME/Downloads" "$HOME/github" "$HOME/code" "$HOME/backups")
  for dir in "${dirs[@]}"; do
    if [ ! -d "$dir" ]; then
      echo "Creating directory $dir..."
      mkdir -p "$dir" || {
        echo_error "Error creating directory $dir."
        exit 1
      }
    else
      echo "Ensuring directory $dir exists..."
    fi
  done
}

font_init() {
  # Define font URL
  font_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/CascadiaCode.zip"
  downloads_dir="$HOME/Downloads"
  font_dir="$HOME/Library/Fonts"

  echo "Downloading Cascadia Code Nerd Font to Downloads folder..."
  
  # Download font to Downloads folder
  curl -L "$font_url" -o "$downloads_dir/CascadiaCode.zip"
  
  # Unzip and install font
  echo "Installing font..."
  unzip -o "$downloads_dir/CascadiaCode.zip" -d "$font_dir"
  rm "$downloads_dir/CascadiaCode.zip" # Clean up zip file after installation

  echo "Cascadia Code Nerd Font installation complete. Please manually set it as the default font in your terminal application."
}

backup_config_files() {
    echo "Searching and backing up .zshrc and starship.toml files to ~/backups"

    # Define the backup directory and ensure it exists
    backupDir="$HOME/backups"
    mkdir -p "$backupDir"

    # Files to search and backup
    declare -a configFiles=(".zshrc" "starship.toml")

    for configFile in "${configFiles[@]}"; do
        # Find and backup config files
        find "$HOME" -name "$configFile" 2>/dev/null | while read -r file; do
            backupFileName="$(basename "$file").backup_$(date +%Y-%m-%d_%H-%M-%S)"
            echo "Backing up $file to $backupDir/$backupFileName"
            mv "$file" "$backupDir/$backupFileName"
        done
    done

    echo -e "Linking new bash config file..."
    ## Make symbolic link.
    ln -svf ${GITPATH}/.bashrc $HOME/.bashrc
    ln -svf ${GITPATH}/starship.toml $HOME/.config/starship.toml
}

# Call functions to install dependencies and create directories
prompt_for_confirmation
install_deps
create_dirs
font_init
backup_config_files

# Configure shell enhancements
echo "Configuring Zsh enhancements..."
{
  echo 'eval "$(starship init zsh)"'
  echo 'source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh'
  echo '[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh'
  echo 'source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh'
} >> ~/.zshrc || {
  echo_error "Error configuring Zsh enhancements."
  exit 1
}

# Write the Starship configuration
echo "Configuring Starship..."
cat <<EOF >~/.config/starship.toml
# Your Starship configuration goes here
EOF || {
  echo_error "Error configuring Starship."
  exit 1
}

echo "Installation and configuration complete. Please run 'source ~/.zshrc' or reopen your terminal to apply the changes."
