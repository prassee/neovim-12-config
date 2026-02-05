-- =============================================================================
-- SECTION 1: GLOBALS & OPTIONS
-- =============================================================================
--
-- -----------------------------------------------------------------------------
-- Leader & Global Variables
-- -----------------------------------------------------------------------------
vim.g.mapleader = " "
vim.g.have_nerd_font = true
vim.g.copilot_no_tab_map = true -- Disable default Copilot tab mapping
vim.opt.clipboard = "unnamedplus"

-- -----------------------------------------------------------------------------
-- Disable Built-in Completion (use blink.cmp instead)
-- -----------------------------------------------------------------------------
vim.g.native_lsp_completion = false -- Disable Neovim 0.11+ native LSP completion

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

-- -----------------------------------------------------------------------------
-- Whitespace Characters
-- -----------------------------------------------------------------------------
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- -----------------------------------------------------------------------------
-- Search
-- -----------------------------------------------------------------------------
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = "split"

-- -----------------------------------------------------------------------------
-- Text Wrapping
-- -----------------------------------------------------------------------------
vim.opt.wrap = true
vim.opt.breakindent = true

-- -----------------------------------------------------------------------------
-- Tabs & Indentation
-- -----------------------------------------------------------------------------
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

-- -----------------------------------------------------------------------------
-- Window Splitting
-- -----------------------------------------------------------------------------
vim.opt.splitright = true
vim.opt.splitbelow = true

-- -----------------------------------------------------------------------------
-- Persistence
-- -----------------------------------------------------------------------------
vim.opt.undofile = true

-- -----------------------------------------------------------------------------
-- Syntax
-- -----------------------------------------------------------------------------
-- Keep Vim syntax enabled as fallback when Treesitter parser unavailable

-- -----------------------------------------------------------------------------
-- Diagnostics
-- -----------------------------------------------------------------------------
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

-- =============================================================================
-- SECTION 2: PACKAGE INSTALLATION
-- =============================================================================

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
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/Saghen/blink.cmp",
	"https://github.com/L3MON4D3/LuaSnip",
	"https://github.com/rafamadriz/friendly-snippets",
	"https://github.com/nvim-mini/mini.clue",
	"https://github.com/nvim-mini/mini.surround",
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
	"https://github.com/sudo-tee/opencode.nvim", -- Plugin causes freeze on toggle
	"https://github.com/github/copilot.vim",
	"https://github.com/numToStr/Comment.nvim",
	"https://github.com/lewis6991/gitsigns.nvim",
	"https://github.com/chomosuke/typst-preview.nvim",
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
