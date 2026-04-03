-- =============================================================================
-- SECTION 1: GLOBALS & OPTIONS
-- =============================================================================
--
-- -----------------------------------------------------------------------------
-- Leader & Global Variables
-- -----------------------------------------------------------------------------
vim.g.mapleader = " " -- Set space as the leader key for custom mappings
vim.g.maplocalleader = "\\"
vim.opt.timeoutlen = 50
-- Prevent <Space> from moving the cursor in normal/visual mode (avoids timeoutlen delay)
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
vim.g.have_nerd_font = true -- Indicate that a Nerd Font is available for icons
vim.g.copilot_enabled = true -- Enable Copilot
vim.g.copilot_no_tab_map = true -- Disable default Copilot tab mapping to avoid conflicts
vim.g.copilot_filetypes = { AgenticInput = false, lua = true, go = true, python = true, rust = true, gitcommit = true } -- Disable Copilot on agentic.nvim prompt input
vim.opt.clipboard = "unnamedplus" -- Use system clipboard for all operations

-- declare a simple function

-- -----------------------------------------------------------------------------
-- Line Numbers
-- -----------------------------------------------------------------------------
vim.opt.number = true
vim.opt.relativenumber = false

-- -----------------------------------------------------------------------------
-- UI
-- -----------------------------------------------------------------------------
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.winborder = "rounded"

vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = "split"

vim.opt.wrap = true
vim.opt.breakindent = true
vim.opt.foldmethod = "manual"

vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.undofile = true

vim.diagnostic.config({
	virtual_lines = {
		current_line = true,
	},
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = { border = "rounded", source = true },
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "✘",
			[vim.diagnostic.severity.WARN] = "⚠",
			[vim.diagnostic.severity.INFO] = "💡",
			[vim.diagnostic.severity.HINT] = "ℹ",
		},
		numhl = {
			[vim.diagnostic.severity.ERROR] = "ErrorMsg",
			[vim.diagnostic.severity.WARN] = "WarningMsg",
		},
	},
})

-- -----------------------------------------------------------------------------
-- Pack Command
-- -----------------------------------------------------------------------------
vim.api.nvim_create_user_command("Pack", function(opts)
	local cmd = opts.fargs[1]
	if cmd == "update" then
		vim.pack.update()
	else
		print("Usage: :Pack [update]")
	end
end, {
	nargs = 1,
	complete = function()
		return { "update" }
	end,
})

-- -----------------------------------------------------------------------------
-- Core Plugins
-- -----------------------------------------------------------------------------
vim.pack.add({
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/Saghen/blink.cmp",
	"https://github.com/L3MON4D3/LuaSnip",
	"https://github.com/rafamadriz/friendly-snippets",
	"https://github.com/nvim-mini/mini.clue",
	"https://github.com/nvim-mini/mini.surround",
	"https://github.com/carlos-algms/agentic.nvim",
})

-- -----------------------------------------------------------------------------
-- LSP & Mason
-- -----------------------------------------------------------------------------
vim.pack.add({
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/mason-org/mason-lspconfig.nvim",
	"https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
	"https://github.com/b0o/SchemaStore.nvim",
})

-- -----------------------------------------------------------------------------
-- UI Plugins
-- -----------------------------------------------------------------------------
vim.pack.add({
	"https://github.com/catppuccin/nvim",
	"https://github.com/nvim-lualine/lualine.nvim",
})

-- -----------------------------------------------------------------------------
-- File & Search
-- -----------------------------------------------------------------------------
vim.pack.add({
	"https://github.com/stevearc/oil.nvim",
	"https://github.com/ibhagwan/fzf-lua",
})

-- -----------------------------------------------------------------------------
-- Tools
-- -----------------------------------------------------------------------------
vim.pack.add({
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/akinsho/toggleterm.nvim",
	"https://github.com/viniciusteixeiradias/kanban.nvim",
	"https://github.com/github/copilot.vim",
	"https://github.com/numToStr/Comment.nvim",
	"https://github.com/lewis6991/gitsigns.nvim",
	"https://github.com/NeogitOrg/neogit",
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/chomosuke/typst-preview.nvim",
	"https://github.com/dangooddd/pyrepl.nvim",
})

-- =============================================================================
-- SECTION 3: PACKAGE CONFIGURATION
-- =============================================================================
require("plugins")

-- =============================================================================
-- SECTION 4: AUTOCOMMANDS
-- =============================================================================

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- =============================================================================
-- SECTION 5: KEYMAPS
-- =============================================================================
require("keymaps")
