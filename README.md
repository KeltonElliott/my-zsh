# my-zsh Documentation

This document outlines the functionality and purpose of the provided setup script. The script is designed to automate the setup process on a macOS system, installing a variety of development tools and utilities, creating necessary directories, and configuring the Zsh shell environment for optimal use.

## Script Features

- **Homebrew Installation**: Checks for and installs Homebrew, the package manager for macOS.
- **Software Installation**: Installs a curated list of formulae and applications via Homebrew.
- **Directory Structure Creation**: Creates a set of directories in the user's home folder for organization.
- **Font Installation**: Downloads and installs the Cascadia Code Nerd Font.
- **Backup of Configuration Files**: Backs up existing `.zshrc` and `starship.toml` configuration files.
- **Shell Enhancements**: Configures Zsh with syntax highlighting, autosuggestions, and other improvements.

## Software Installed

The script installs the following software:

### Homebrew Formulae

- **[Starship](https://starship.rs/)**: A minimal, blazing-fast, and infinitely customizable prompt for any shell.
- **[Zsh Syntax Highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)**: Provides syntax highlighting for the shell Zsh.
- **[Autojump](https://github.com/wting/autojump)**: A faster way to navigate your filesystem.
- **[Zsh Autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)**: Suggests commands as you type based on history and completions.
- **[Git](https://git-scm.com/)**: A free and open-source distributed version control system.
- **[Zsh Completions](https://github.com/zsh-users/zsh-completions)**: Additional completion definitions for Zsh.
- **[Pyenv](https://github.com/pyenv/pyenv)**: A tool that allows for easy installation and management of multiple Python versions on a single system. It enables you to switch between Python versions on a per-project basis, ensuring compatibility and ease of development across different environments.

### Homebrew Casks

- **[Visual Studio Code](https://code.visualstudio.com/)**: A source-code editor made by Microsoft.
- **[Raycast](https://www.raycast.com/)**: Makes it simple, fast, and delightful to control your tools.
- **[Docker Desktop](https://www.docker.com/products/docker-desktop)**: The easiest and fastest way to use Docker on your laptop.
- **[AltTab](https://alt-tab-macos.netlify.app/)**: Brings the power of Windows’s “alt-tab” window switcher to macOS.
- **[Hidden Bar](https://github.com/dwarvesf/hidden)**: A utility that allows you to hide menu bar items.
- **[Stats](https://github.com/exelban/stats)**: An application that allows you to monitor your macOS system.
- **[Firefox Developer Edition](https://www.mozilla.org/en-US/firefox/developer/)**: The Firefox browser built for developers.
- **[Spotify](https://www.spotify.com/)**: A digital music service that gives you access to millions of songs.
- **[iTerm2](https://iterm2.com/)**: iTerm2 is a replacement for Terminal and the successor to iTerm.

## Directories Created

The script creates the following directories in the user's home folder:

- `.config`: For storing configuration files.
- `github`: A directory for GitHub projects.
- `code`: A directory for coding projects.
- `backups`: For backing up important files.

## Usage

To use this script, you must first make it executable and then run it:

```sh
chmod +x setup.sh
./setup.sh
