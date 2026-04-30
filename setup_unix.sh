#!/bin/bash

# Get the absolute path of the directory where this script is located
DOTFILES_DIR=$(cd "$(dirname "$0")"; pwd)

echo "Starting Unix environment configuration..."

# 1. Function to create symbolic links (automatically backs up existing files)
link_file() {
    local src=$1
    local dest=$2
    
    # Check if the destination already exists or is a broken symlink
    if [ -e "$dest" ] || [ -L "$dest" ]; then
        if [ ! -L "$dest" ]; then
            echo "Backing up existing file: $dest -> ${dest}.bak"
            mv "$dest" "${dest}.bak"
        else
            echo "Removing old symbolic link: $dest"
            rm "$dest"
        fi
    fi
    
    # Create the link
    ln -s "$src" "$dest"
    echo "Linked: $dest"
}

# 2. Base Configuration Files (Dotfiles)
# Linking core configuration files shown in image_0e283f.png
link_file "$DOTFILES_DIR/.gitconfig"  "$HOME/.gitconfig"
link_file "$DOTFILES_DIR/.inputrc"    "$HOME/.inputrc"
link_file "$DOTFILES_DIR/.dircolors"  "$HOME/.dircolors"
link_file "$DOTFILES_DIR/.emacs.d"    "$HOME/.emacs.d"

# 3. Shell Environment Integration
# Instead of overwriting ~/.bashrc, we source the repository's init script
if [ -f "$DOTFILES_DIR/bash_init.sh" ]; then
    if ! grep -q "bash_init.sh" "$HOME/.bashrc"; then
        echo -e "\n# Load custom dev environment\nsource $DOTFILES_DIR/bash_init.sh" >> "$HOME/.bashrc"
        echo "Added bash_init.sh to ~/.bashrc"
    fi
fi

# Run the Zsh setup if the script exists
if [ -f "$DOTFILES_DIR/zsh_setup.sh" ]; then
    echo "Running Zsh setup script..."
    bash "$DOTFILES_DIR/zsh_setup.sh"
fi

echo "--- Configuration Complete ---"
echo "Please run 'source ~/.bashrc' or restart your terminal to apply changes."

