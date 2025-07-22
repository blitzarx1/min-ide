# min-ide

**Brutally minimal. Terminal-native. Git-ready.**

A Neovim-powered IDE in a Docker image — no setup, no pollution, just code.

## Features

* 🐳 Dockerized Neovim (no need to install anything locally)
* 🔐 SSH key forwarding for Git over SSH
* ⚙️ Support for custom `.gitconfig`
* 🧠 Vim-fugitive preinstalled (Git integration in Neovim)
* 🌈 Rose Pine color scheme preinstalled (`moon` variant)
* 💡 Built-in autocompletion with `nvim-cmp` (buffer, path, cmdline)
* 🌳 Tree-sitter installed and enabled for modern syntax highlighting
* ⌨️ Optional `ide` CLI with autocompletion
* 🧰 `jq` installed for JSON processing in terminal
* 🚀 Zero configuration: just run `ide` in any project directory

## Installation

```sh
./install.sh
```

This:

* Builds the Docker image
* Installs `ide` executable to your local binary folder (e.g., `/usr/local/bin`)

## Usage

```sh
ide                   # Open Neovim in current directory
ide path/to/file      # Open specific file (relative or absolute)
ide path/to/dir       # Open directory (relative or absolute)
ide --dry-run         # Show the Docker run command without executing it
ide --gitconfig ~/.gitconfig.local  # Use a custom Git config
```

## Git & SSH Notes

* Your `~/.ssh` directory and `.gitconfig` (default or custom) are mounted read-only into the container.

## Configuration

To customize Neovim behavior, edit `.config/nvim/init.lua` before building.
This file will be copied into the container during image build.

## Development Notes

* Uses no plugin manager — plugins like `vim-fugitive`, `nvim-cmp`, and `tree-sitter` are cloned directly during build
* Color scheme (`rose-pine`), syntax highlighting (via `tree-sitter`), and autocompletion sources (`cmp-buffer`, `cmp-path`, `cmp-cmdline`) are configured manually
* **Note**: Tree-sitter requires a C compiler. The Docker image installs Alpine's `build-base` meta-package to provide `gcc`, `make`, and `libc` to ensure parsers compile successfully.
