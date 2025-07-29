-- line numbers: start
vim.o.number = true
vim.o.relativenumber = true
-- line number: end

-- tabs: start
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.expandtab = false
-- tabs: end

-- leader: start
vim.g.mapleader = " "
-- leader: end

-- remaps: start
local map   = vim.keymap.set
local opts  = { noremap = true, silent = true }

-- remaps: windows: start
map('n', '<C-h>', '<cmd>wincmd h<CR>', opts)
map('n', '<C-j>', '<cmd>wincmd j<CR>', opts)
map('n', '<C-k>', '<cmd>wincmd k<CR>', opts)
map('n', '<C-l>', '<cmd>wincmd l<CR>', opts)

vim.api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
  callback = function()
    local opts = { noremap = true, silent = true, buffer = true }
    vim.keymap.set("n", "<C-h>", "<C-w>h", opts)
    vim.keymap.set("n", "<C-j>", "<C-w>j", opts)
    vim.keymap.set("n", "<C-k>", "<C-w>k", opts)
    vim.keymap.set("n", "<C-l>", "<C-w>l", opts)
  end,
})
-- remaps: windows: end
-- remaps: end

-- color: start
vim.o.syntax = "enable"

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
	vim.api.nvim_set_hl(0, "NonText",   { fg = "#404040", bg = "NONE" })

	local bg = "#eb6f92"
	local fg = "#ffffff"
	vim.api.nvim_set_hl(0, "Visual",   { bg = bg, fg = fg })
	vim.api.nvim_set_hl(0, "VisualNOS",{ bg = bg, fg = fg })
  end,
})

-- colorscheme
require("rose-pine").setup({  
	variant = "moon",
	styles = {
		italic = false,
	},
})

vim.cmd("colorscheme rose-pine")
-- color: end

-- special: start
vim.o.list = true
vim.o.listchars = "tab:▸ ,space:·,trail:·,extends:›,precedes:‹,eol:$"
vim.o.wrap = false
-- special:end

-- vim-fugitive: start
vim.cmd([[ cabbrev gg Git ]])
-- vim-fugitive: end

-- cmp: start
local cmp = require("cmp")

cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  }),
  sources = {
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "path" },
  },
})

cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "path" },
    { name = "cmdline" },
  },
})
-- cmp: end

-- lsp: start
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "gopls" },
  automatic_installation = false,
})

local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- LSP keymaps
local on_attach = function(client, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "<leader>i", vim.lsp.buf.implementation, opts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, opts)
  vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, opts)
  vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end, opts)
end

-- Setup gopls
lspconfig.gopls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
      gofumpt = true,
    },
  },
})
-- lsp: end

-- overseer: start
require("overseer").setup({
  templates = { "builtin", "user.go_build", "user.go_run", "user.go_test" },
})

-- Task keymaps
vim.keymap.set("n", "<leader>oo", "<cmd>OverseerOpen<cr>", { desc = "Open task list" })
vim.keymap.set("n", "<leader>or", "<cmd>OverseerRun<cr>", { desc = "Run task" })
vim.keymap.set("n", "<leader>ot", "<cmd>OverseerToggle<cr>", { desc = "Toggle task list" })
-- overseer: end
-- treesitter: start
require'nvim-treesitter.configs'.setup {
  ensure_installed = { 
	  "lua", "bash", "json", "yaml", "markdown", "vim", "dockerfile",
	  "go", "rust", "c", "cpp",
  },
  auto_install = false,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}
-- treesitter: end
