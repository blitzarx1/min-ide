FROM arm64v8/alpine:latest

ARG PROJECT_PATH=/project
ARG PLUGIN_DIR=/root/.config/nvim/pack/vendor/start
ARG COLORSCHEME_DIR=/root/.config/nvim/colors

RUN apk add --no-cache \
  git \
  neovim \
  openssh-client \
  neovim-doc \
  jq \
  build-base \
  go \
  curl \
  gzip \
  bash \
  unzip

COPY .config/nvim /root/.config/nvim

# install vim-fugitive
RUN mkdir -p ${PLUGIN_DIR} && \
    git clone --depth=1 https://github.com/tpope/vim-fugitive.git ${PLUGIN_DIR}/vim-fugitive

# install nvim-cmp and completion sources
RUN git clone --depth=1 https://github.com/hrsh7th/nvim-cmp.git ${PLUGIN_DIR}/nvim-cmp && \
    git clone --depth=1 https://github.com/hrsh7th/cmp-buffer.git ${PLUGIN_DIR}/cmp-buffer && \
    git clone --depth=1 https://github.com/hrsh7th/cmp-path.git ${PLUGIN_DIR}/cmp-path && \
    git clone --depth=1 https://github.com/hrsh7th/cmp-cmdline.git ${PLUGIN_DIR}/cmp-cmdline && \
    git clone --depth=1 https://github.com/hrsh7th/cmp-nvim-lsp.git ${PLUGIN_DIR}/cmp-nvim-lsp

# install LSP related plugins
RUN git clone --depth=1 https://github.com/neovim/nvim-lspconfig.git ${PLUGIN_DIR}/nvim-lspconfig && \
    git clone --depth=1 https://github.com/williamboman/mason.nvim.git ${PLUGIN_DIR}/mason.nvim && \
    git clone --depth=1 https://github.com/williamboman/mason-lspconfig.nvim.git ${PLUGIN_DIR}/mason-lspconfig.nvim

# install task runner
RUN git clone --depth=1 https://github.com/stevearc/overseer.nvim.git ${PLUGIN_DIR}/overseer.nvim

# tree-sitter cli + plugin
RUN apk add --no-cache tree-sitter && \
    git clone --depth=1 https://github.com/nvim-treesitter/nvim-treesitter.git ${PLUGIN_DIR}/nvim-treesitter

# install rose-pine color scheme
RUN mkdir -p ${COLORSCHEME_DIR} && \
	git clone --depth=1 https://github.com/rose-pine/neovim.git ${PLUGIN_DIR}/rose-pine

# Pre-install treesitter parsers (after all plugins are installed)
RUN nvim --headless -c "TSInstallSync lua bash json yaml markdown vim dockerfile go rust c cpp" -c "qa"

# Pre-install gopls via Mason (separate step to avoid conflicts)
RUN nvim --headless -c "lua require('mason.api.command').MasonInstall({'gopls'})" -c "qa"

WORKDIR ${PROJECT_PATH}
