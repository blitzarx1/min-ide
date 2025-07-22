#!/bin/sh

set -e

IMAGE_NAME="ide"
EXECUTABLE_NAME="ide"
PROJECT_PATH="/project"
INSTALL_DIR="$HOME/bin"
BASH_COMPLETION_FILE="$HOME/.bash_completion"
ZSH_COMPLETION_DIR="$HOME/.zsh/site-functions"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Build Docker image
echo "[*] Building Docker image: $IMAGE_NAME"
docker build -t "$IMAGE_NAME" --build-arg PROJECT_PATH="$PROJECT_PATH" "$SCRIPT_DIR"

# Install the executable
echo "[*] Installing $EXECUTABLE_NAME to $INSTALL_DIR"
mkdir -p "$INSTALL_DIR"
cp "$SCRIPT_DIR/$EXECUTABLE_NAME" "$INSTALL_DIR/$EXECUTABLE_NAME"
chmod +x "$INSTALL_DIR/$EXECUTABLE_NAME"

# Install tab completion
SHELL_NAME="$(basename "$SHELL")"
echo "[*] Installing autocompletion for $SHELL_NAME"

case "$SHELL_NAME" in
  bash)
    mkdir -p "$(dirname "$BASH_COMPLETION_FILE")"
    grep -q "ide completion" "$BASH_COMPLETION_FILE" 2>/dev/null || {
      echo "# ide completion" >> "$BASH_COMPLETION_FILE"
      cat "$SCRIPT_DIR/ide-completion.sh" >> "$BASH_COMPLETION_FILE"
    }
    ;;
  zsh)
    mkdir -p "$ZSH_COMPLETION_DIR"
    cp "$SCRIPT_DIR/ide-completion.zsh" "$ZSH_COMPLETION_DIR/_ide"
    echo "fpath+=($ZSH_COMPLETION_DIR)" >> "$HOME/.zshrc"
    echo "autoload -Uz compinit && compinit" >> "$HOME/.zshrc"
    ;;
  *)
    echo "[!] Shell '$SHELL_NAME' not supported for completion setup."
    ;;
esac

echo "[✔] Done. You can now run 'ide [optional-path]'"
