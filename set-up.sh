#!/bin/zsh

# Formulae to be installed
formulae=(
  "Starship"
  "zsh-syntax-highlighting"
  "autojump"
  "zsh-autosuggestions"
  "git"
  "zsh-completions"
  "pyenv"
)

# Casks to be installed

casks=(
  "visual-studio-code"
  "raycast"
  "alt-tab"
  "hiddenbar"
  "stats"
  "firefox-developer-edition"
  "spotify"
  "iterm2"
)

# Directories
directories=(
  "$HOME/.config"
  "$HOME/github"
  "$HOME/code"
  "$HOME/backups"
)

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
  echo "- Install the following formulae using Homebrew:"
  for formula in "${formulae[@]}"; do
    echo "  - $formula"
  done
  echo "- Install the following applications using Homebrew Casks:"
  for cask in "${casks[@]}"; do
    echo "  - $cask"
  done
  echo "- Create the following directories in your home folder:"
  for dir in "${directories[@]}"; do
    echo "  - $dir"
  done
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

  # Tap the homebrew/cask-versions for Firefox Developer Edition
  echo "Tapping homebrew/cask-versions..."
  brew tap homebrew/cask-versions

  # Install formulae
  for formula in "${formulae[@]}"; do
    echo "Installing $formula..."
    brew install $formula || {
      echo_error "Error installing $formula."
      exit 1
    }
  done

  # Install casks
  for cask in "${casks[@]}"; do
    echo "Installing $cask..."
    brew install --cask $cask || {
      echo_error "Error installing $cask."
      exit 1
    }
  done
}

create_dirs() {
  for dir in "${directories[@]}"; do
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
    echo "Backing up .zshrc and starship.toml files to ~/backups..."

    # Define the path to the backups directory
    backupDir="$HOME/backups"

    # Define the paths of the files to be backed up
    zshrcFile="$HOME/.zshrc"
    starshipFile="$HOME/.config/starship.toml"

    # Backup .zshrc if it exists
    if [[ -f "$zshrcFile" ]]; then
        echo "Backing up .zshrc to $backupDir"
        mv "$zshrcFile" "$backupDir/.zshrc.backup_$(date +%Y-%m-%d_%H-%M-%S)"
    else
        echo ".zshrc does not exist, skipping."
    fi

    # Backup starship.toml if it exists
    if [[ -f "$starshipFile" ]]; then
        echo "Backing up starship.toml to $backupDir"
        mv "$starshipFile" "$backupDir/starship.toml.backup_$(date +%Y-%m-%d_%H-%M-%S)"
    else
        echo "starship.toml does not exist, skipping."
    fi
    
    echo -e "Linking new zsh config file..."
    ## Make symbolic link.
    ln -svf ${GITPATH}/.zshrc $HOME/.zshrc
    ln -svf ${GITPATH}/starship.toml $HOME/.config/starship.toml
}

# Call functions to install dependencies and create directories
prompt_for_confirmation
install_deps
create_dirs
font_init
backup_config_files

# Configure shell enhancements
echo "Configuring Zsh enhancements and Pyenv initialization..."
{
  echo 'eval "$(starship init zsh)"'
  echo 'source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh'
  echo '[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh'
  echo 'source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh'
  # Pyenv initialization
  echo 'export PYENV_ROOT="$HOME/.pyenv"'
  echo 'export PATH="$PYENV_ROOT/bin:$PATH"'
  echo 'if command -v pyenv 1>/dev/null 2>&1; then'
  echo '  eval "$(pyenv init --path)"'
  echo 'fi'
  echo 'if command -v pyenv virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi'
} >> ~/.zshrc || {
  echo_error "Error configuring Zsh enhancements."
  exit 1
}


echo "Installation and configuration complete. Please run: 'source ~/.zshrc' or reopen your terminal to apply the changes."
echo "Please review the READNE.md document for all details regarding this script"
