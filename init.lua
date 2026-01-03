-- =============================================================================
-- SECTION 1: GLOBALS & OPTIONS
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Leader & Global Variables
-- -----------------------------------------------------------------------------
vim.g.mapleader = "\\"
vim.g.have_nerd_font = true
vim.g.copilot_no_tab_map = true -- Disable default Copilot tab mapping

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
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/Saghen/blink.cmp",
	"https://github.com/L3MON4D3/LuaSnip",
	"https://github.com/rafamadriz/friendly-snippets",
	"https://github.com/nvim-mini/mini.clue",
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
	"https://github.com/NickvanDyke/opencode.nvim",
	"https://github.com/github/copilot.vim",
	"https://github.com/numToStr/Comment.nvim",
	"https://github.com/lewis6991/gitsigns.nvim",
})

-- =============================================================================
-- SECTION 3: PACKAGE CONFIGURATION
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Colorscheme
-- -----------------------------------------------------------------------------
vim.cmd.colorscheme("catppuccin")

-- -----------------------------------------------------------------------------
-- Treesitter
-- -----------------------------------------------------------------------------
-- Enable treesitter highlighting when parser is available, fallback to vim syntax
vim.api.nvim_create_autocmd("FileType", {
	callback = function()
		pcall(vim.treesitter.start)
	end,
})

-- -----------------------------------------------------------------------------
-- Mason & LSP Setup
-- -----------------------------------------------------------------------------
require("mason").setup()
require("mason-lspconfig").setup()
require("mason-tool-installer").setup({
	ensure_installed = {
		"lua_ls",
		"stylua",
		"pyrefly",
		"gopls",
		"yaml-language-server",
		"prettier",
	},
})

vim.lsp.enable({ "lua_ls", "gopls", "pyrefly", "dockerls", "taplo", "jsonls", "marksman", "yamlls" })
vim.lsp.inlay_hint.enable(true)

-- -----------------------------------------------------------------------------
-- LSP Server Configurations
-- -----------------------------------------------------------------------------
vim.lsp.config("lua_ls", {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { { ".luarc.json", ".luarc.jsonc" }, ".git" },
	settings = {
		Lua = {
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			},
			runtime = {
				version = "LuaJIT",
			},
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
})

vim.lsp.config("gopls", {
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gowork", "gotmpl", "gosum" },
	root_markers = { "go.mod", "go.work", ".git" },
	settings = {
		gopls = {
			gofumpt = true,
			codelenses = {
				gc_details = false,
				generate = true,
				regenerate_cgo = true,
				run_govulncheck = true,
				test = true,
				tidy = true,
				upgrade_dependency = true,
				vendor = true,
			},
			hints = {
				assignVariableTypes = true,
				compositeLiteralFields = true,
				compositeLiteralTypes = true,
				constantValues = true,
				functionTypeParameters = true,
				parameterNames = true,
				rangeVariableTypes = true,
			},
			analyses = {
				nilness = true,
				unusedparams = true,
				unusedwrite = true,
				useany = true,
				unreachable = true,
				modernize = true,
				stylecheck = true,
				appends = true,
				asmdecl = true,
				assign = true,
				atomic = true,
				bools = true,
				buildtag = true,
				cgocall = true,
				composite = true,
				contextcheck = true,
				deba = true,
				atomicalign = true,
				composites = true,
				copylocks = true,
				deepequalerrors = true,
				defers = true,
				deprecated = true,
				directive = true,
				embed = true,
				errorsas = true,
				fillreturns = true,
				framepointer = true,
				gofix = true,
				hostport = true,
				infertypeargs = true,
				lostcancel = true,
				httpresponse = true,
				ifaceassert = true,
				loopclosure = true,
				nilfunc = true,
				nonewvars = true,
				noresultvalues = true,
				printf = true,
				shadow = true,
				shift = true,
				sigchanyzer = true,
				simplifycompositelit = true,
				simplifyrange = true,
				simplifyslice = true,
				slog = true,
				sortslice = true,
				stdmethods = true,
				stdversion = true,
				stringintconv = true,
				structtag = true,
				testinggoroutine = true,
				tests = true,
				timeformat = true,
				unmarshal = true,
				unsafeptr = true,
				unusedfunc = true,
				unusedresult = true,
				waitgroup = true,
				yield = true,
				unusedvariable = true,
			},
			usePlaceholders = true,
			completeUnimported = true,
			staticcheck = true,
			directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
			semanticTokens = true,
		},
	},
})

vim.lsp.config("dockerls", {
	cmd = { "docker-langserver", "--stdio" },
	filetypes = { "dockerfile" },
	root_markers = { "Dockerfile", "Containerfile", ".git" },
	single_file_support = true,
})

vim.lsp.config("taplo", {
	cmd = { "taplo", "lsp", "stdio" },
	filetypes = { "toml" },
	root_markers = { "*.toml", ".git" },
	single_file_support = true,
})

vim.lsp.config("jsonls", {
	cmd = { "vscode-json-language-server", "--stdio" },
	filetypes = { "json", "jsonc" },
	root_markers = { "package.json", ".git" },
	single_file_support = true,
	settings = {
		json = {
			schemas = require("schemastore").json.schemas(),
			validate = { enable = true },
		},
	},
})

vim.lsp.config("marksman", {
	cmd = { "marksman", "server" },
	filetypes = { "markdown", "markdown.mdx" },
	root_markers = { "README.md", ".git" },
	single_file_support = true,
})

vim.lsp.config("yamlls", {
	cmd = { "yaml-language-server", "--stdio" },
	filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab" },
	root_markers = { ".git" },
	single_file_support = true,
	settings = {
		yaml = {
			schemas = require("schemastore").yaml.schemas(),
			validate = true,
			schemaStore = {
				enable = false, -- Disable built-in schemaStore to use schemastore.nvim
				url = "",
			},
		},
	},
})

-- -----------------------------------------------------------------------------
-- Completion (blink.cmp)
-- -----------------------------------------------------------------------------
vim.opt.completeopt = {} -- Disable Neovim's built-in completion menu

require("blink.cmp").setup({
	keymap = {
		["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
		["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
		["<CR>"] = { "accept", "fallback" },
		["<Esc>"] = { "hide", "fallback" },
		["<PageUp>"] = { "scroll_documentation_up", "fallback" },
		["<PageDown>"] = { "scroll_documentation_down", "fallback" },
	},
	signature = { enabled = true },
	fuzzy = { implementation = "lua" },
	completion = {
		documentation = { auto_show = true, auto_show_delay_ms = 250 },
		menu = {
			auto_show = true,
			draw = {
				treesitter = { "lsp" },
				columns = { { "kind_icon", "label", "label_description", gap = 1 }, { "kind" } },
			},
		},
	},
	sources = {
		default = { "lsp", "path", "snippets" },
	},
})

-- -----------------------------------------------------------------------------
-- Comment
-- -----------------------------------------------------------------------------
require("Comment").setup()

-- -----------------------------------------------------------------------------
-- Formatting (conform.nvim)
-- -----------------------------------------------------------------------------
require("conform").setup({
	format_on_save = {
		timeout_ms = 500,
		lsp_format = "fallback",
	},
	formatters_by_ft = {
		lua = { "stylua" },
		json = { "jq" },
		rust = { "rustfmt" },
		python = { "black" },
		go = { "gofmt" },
		htmldjango = { "djlint" },
		html = { "djlint" },
		javascript = { "prettier" },
		yaml = { "prettier" },
	},
})

-- -----------------------------------------------------------------------------
-- File Explorer (oil.nvim)
-- -----------------------------------------------------------------------------
require("oil").setup({
	keymaps = { ["`"] = "actions.tcd" },
	columns = { "size", "mtime" },
	delete_to_trash = true,
	skip_confirm_for_simple_edits = true,
})

-- -----------------------------------------------------------------------------
-- Fuzzy Finder (fzf-lua)
-- -----------------------------------------------------------------------------
local fzf = require("fzf-lua")
fzf.setup({
	files = {
		cmd = "git ls-files --cached --others --exclude-standard 2>/dev/null || rg --files --hidden --glob '!/.git/*'",
	},
})
fzf.register_ui_select()

-- -----------------------------------------------------------------------------
-- Statusline (lualine)
-- -----------------------------------------------------------------------------
require("lualine").setup({
	options = {
		theme = "auto",
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = { "filename" },
		lualine_x = { "encoding", "fileformat", "filetype", "lsp_status" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
})

-- -----------------------------------------------------------------------------
-- Which-Key Hints (mini.clue)
-- -----------------------------------------------------------------------------
require("mini.clue").setup({
	triggers = {
		{ mode = "n", keys = "<Leader>" },
		{ mode = "x", keys = "<Leader>" },
		{ mode = "i", keys = "<C-x>" },
		{ mode = "n", keys = "g" },
		{ mode = "x", keys = "g" },
		{ mode = "n", keys = "'" },
		{ mode = "n", keys = "`" },
		{ mode = "x", keys = "'" },
		{ mode = "x", keys = "`" },
		{ mode = "n", keys = '"' },
		{ mode = "x", keys = '"' },
		{ mode = "i", keys = "<C-r>" },
		{ mode = "c", keys = "<C-r>" },
		{ mode = "n", keys = "<C-w>" },
		{ mode = "n", keys = "z" },
		{ mode = "x", keys = "z" },
	},
})

-- -----------------------------------------------------------------------------
-- Terminal (toggleterm)
-- -----------------------------------------------------------------------------
require("toggleterm").setup({
	shade_terminals = true,
})

local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({ cmd = "lazygit", direction = "float", hidden = true })
local thoth = Terminal:new({ cmd = "thoth", direction = "float", hidden = true })

-- -----------------------------------------------------------------------------
-- Git Signs (gitsigns.nvim)
-- -----------------------------------------------------------------------------
require("gitsigns").setup({
	current_line_blame = false, -- Toggle with :Gitsigns toggle_current_line_blame
	current_line_blame_opts = {
		virt_text = true,
		virt_text_pos = "eol",
		delay = 300,
	},
	signs = {
		add = { text = "+" },
		change = { text = "~" },
		delete = { text = "_" },
		topdelete = { text = "-" },
		changedelete = { text = "~" },
	},
})

-- -----------------------------------------------------------------------------
-- Kanban
-- -----------------------------------------------------------------------------
require("kanban").setup({
	file = {
		path = nil,
		name = "TODO.md",
		create_if_missing = true,
	},
	default_columns = { "Backlog", "In Progress", "Done" },
	window = {
		width = 0.8,
		height = 0.6,
		border = "rounded",
	},
	auto_refresh_buffers = true,
	on_complete_move_to = "Done",
})

-- -----------------------------------------------------------------------------
-- OpenCode (AI Assistant)
-- -----------------------------------------------------------------------------
vim.g.opencode_opts = {
	provider = {
		enabled = "terminal",
		terminal = {
			split = "right",
		},
	},
}
local opencode = require("opencode")

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

-- -----------------------------------------------------------------------------
-- General: Saving & Quitting
-- -----------------------------------------------------------------------------
vim.keymap.set({ "n", "i" }, "<leader>s", "<Esc><cmd>w<CR>", { desc = "Save" })
vim.keymap.set("n", "<leader>q", ":wqall<CR>", { desc = "Quit" })
vim.keymap.set("n", "<leader>r", "<cmd>checktime<CR>", { desc = "Refresh file if modified outside" })

-- -----------------------------------------------------------------------------
-- General: Search
-- -----------------------------------------------------------------------------
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- -----------------------------------------------------------------------------
-- General: Line Navigation
-- -----------------------------------------------------------------------------
vim.keymap.set("n", "<leader>a", "^", { desc = "Go to beginning of line" })
vim.keymap.set("n", "<leader>e", "$", { desc = "Go to end of line" })
vim.keymap.set("i", "<C-a>", "<C-o>^", { desc = "Go to beginning of line" })
vim.keymap.set("i", "<C-e>", "<End>", { desc = "Go to end of line" })

-- -----------------------------------------------------------------------------
-- General: Jumplist Navigation
-- -----------------------------------------------------------------------------
vim.keymap.set("n", "<M-left>", "g;", { desc = "Go to older cursor position" })
vim.keymap.set("n", "<M-right>", "g,", { desc = "Go to newer cursor position" })

-- -----------------------------------------------------------------------------
-- General: Buffer Navigation
-- -----------------------------------------------------------------------------
vim.keymap.set("n", "<M-S-left>", "<Esc>:bprevious<Esc>", { desc = "Go to previous visited buffer" })
vim.keymap.set("n", "<M-S-right>", "<Esc>:bnext<Esc>", { desc = "Go to next visited buffer" })

-- -----------------------------------------------------------------------------
-- General: Window Management
-- -----------------------------------------------------------------------------
vim.keymap.set("n", "<leader>g<left>", "<C-w><C-h>", { desc = "Move focus left" })
vim.keymap.set("n", "<leader>g<down>", "<C-w><C-j>", { desc = "Move focus down" })
vim.keymap.set("n", "<leader>g<up>", "<C-w><C-k>", { desc = "Move focus up" })
vim.keymap.set("n", "<leader>g<right>", "<C-w><C-l>", { desc = "Move focus right" })
vim.keymap.set("n", "<leader>Sv", ":vsplit<CR>", { desc = "Vertical Split" })
vim.keymap.set("n", "<leader>Sh", ":split<CR>", { desc = "Horizontal Split" })
vim.keymap.set("n", "<leader>Sc", "<cmd>close<CR>", { desc = "Close Split" })
vim.keymap.set("n", "<leader>So", "<cmd>only<CR>", { desc = "Keep Only This Split" })

-- -----------------------------------------------------------------------------
-- General: Line Movement
-- -----------------------------------------------------------------------------
vim.keymap.set("n", "<M-down>", ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<M-up>", ":m .-2<CR>==", { desc = "Move line up" })

-- -----------------------------------------------------------------------------
-- General: Clipboard
-- -----------------------------------------------------------------------------
vim.keymap.set("n", "<leader>y", "<cmd>%y+<CR>", { desc = "Yank entire buffer to system clipboard" })
vim.keymap.set({ "n", "v" }, "<C-a>", "<Esc>ggVG", { desc = "Select all text" })

-- -----------------------------------------------------------------------------
-- Plugin: Oil (File Explorer)
-- -----------------------------------------------------------------------------
vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "Oil File Explorer" })

-- -----------------------------------------------------------------------------
-- Plugin: fzf-lua (Fuzzy Finder)
-- -----------------------------------------------------------------------------
vim.keymap.set("n", "<leader>ff", fzf.files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fG", fzf.live_grep, { desc = "Grep" })
vim.keymap.set("n", "<leader>fb", fzf.buffers, { desc = "Buffers" })
vim.keymap.set("n", "<leader>fh", fzf.help_tags, { desc = "Help Tags" })
vim.keymap.set("n", "<leader>fC", fzf.commands, { desc = "Commands" })

-- -----------------------------------------------------------------------------
-- Plugin: fzf-lua (LSP Integration)
-- -----------------------------------------------------------------------------
vim.keymap.set("n", "<leader>fr", fzf.lsp_references, { desc = "LSP References" })
vim.keymap.set("n", "<leader>fD", fzf.lsp_definitions, { desc = "LSP Definitions" })
vim.keymap.set("n", "<leader>fca", fzf.lsp_code_actions, { desc = "LSP Code Actions" })
vim.keymap.set("n", "<leader>fs", fzf.lsp_document_symbols, { desc = "LSP Document Symbols" })
vim.keymap.set("n", "<leader>fw", fzf.lsp_workspace_symbols, { desc = "LSP Workspace Symbols" })
vim.keymap.set("n", "<leader>fR", vim.lsp.buf.rename, { desc = "LSP rename" })
vim.keymap.set("n", "<leader>fdd", fzf.diagnostics_document, { desc = "LSP Document Diagnostics" })
vim.keymap.set("n", "<leader>fwd", fzf.diagnostics_workspace, { desc = "LSP Workspace Diagnostics" })

-- -----------------------------------------------------------------------------
-- Plugin: fzf-lua (Git Integration)
-- -----------------------------------------------------------------------------
vim.keymap.set("n", "<leader>fgs", fzf.git_status, { desc = "Git Status" })
vim.keymap.set("n", "<leader>fgc", fzf.git_commits, { desc = "Git Commits" })

-- -----------------------------------------------------------------------------
-- Plugin: Gitsigns (Git Blame / Hunks)
-- -----------------------------------------------------------------------------
vim.keymap.set("n", "<leader>hb", "<cmd>Gitsigns toggle_current_line_blame<CR>", { desc = "Toggle Git Blame" })
vim.keymap.set("n", "<leader>hB", "<cmd>Gitsigns blame<CR>", { desc = "Git Blame Buffer" })
vim.keymap.set("n", "<leader>hp", "<cmd>Gitsigns preview_hunk<CR>", { desc = "Preview Hunk" })
vim.keymap.set("n", "<leader>hr", "<cmd>Gitsigns reset_hunk<CR>", { desc = "Reset Hunk" })
vim.keymap.set("n", "<leader>hR", "<cmd>Gitsigns reset_buffer<CR>", { desc = "Reset Buffer" })
vim.keymap.set("n", "<leader>hd", "<cmd>Gitsigns diffthis<CR>", { desc = "Diff This" })
vim.keymap.set("n", "]h", "<cmd>Gitsigns next_hunk<CR>", { desc = "Next Hunk" })
vim.keymap.set("n", "[h", "<cmd>Gitsigns prev_hunk<CR>", { desc = "Previous Hunk" })

-- -----------------------------------------------------------------------------
-- Plugin: ToggleTerm (Terminal)
-- -----------------------------------------------------------------------------
local function toggle_lazygit()
	lazygit:toggle()
end

local function toggle_thoth()
	thoth:toggle()
end

vim.keymap.set(
	"n",
	"<leader>t",
	":ToggleTerm direction=float<CR>",
	{ noremap = true, silent = true, desc = "Toggle Terminal" }
)
vim.keymap.set("n", "<leader>G", toggle_lazygit, { desc = "Lazygit" })
vim.keymap.set("n", "<leader>T", toggle_thoth, { desc = "Thoth" })
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- -----------------------------------------------------------------------------
-- Plugin: OpenCode (AI Assistant)
-- -----------------------------------------------------------------------------
local function toggle_opencode()
	opencode.toggle()
end

local function ask_about_code()
	opencode.ask("@cursor: ")
end

local function ask_about_selection()
	opencode.ask("@selection: ")
end

local function add_buffer_to_prompt()
	opencode.prompt("@buffer", { append = true })
end

local function add_selection_to_prompt()
	opencode.prompt("@selection", { append = true })
end

local function explain_code()
	opencode.prompt("Explain @cursor and its context")
end

local function new_session()
	opencode.command("session_new")
end

local function scroll_up()
	opencode.command("messages_half_page_up")
end

local function scroll_down()
	opencode.command("messages_half_page_down")
end

local function select_prompt()
	opencode.select()
end

vim.keymap.set("n", "<leader>ot", toggle_opencode, { desc = "Toggle OpenCode" })
vim.keymap.set("n", "<leader>oa", ask_about_code, { desc = "Ask about code" })
vim.keymap.set("v", "<leader>oa", ask_about_selection, { desc = "Ask about selection" })
vim.keymap.set("n", "<leader>o+", add_buffer_to_prompt, { desc = "Add buffer to prompt" })
vim.keymap.set("v", "<leader>o+", add_selection_to_prompt, { desc = "Add selection to prompt" })
vim.keymap.set("n", "<leader>oe", explain_code, { desc = "Explain code" })
vim.keymap.set("n", "<leader>on", new_session, { desc = "New session" })
vim.keymap.set("n", "<S-C-u>", scroll_up, { desc = "Scroll up" })
vim.keymap.set("n", "<S-C-d>", scroll_down, { desc = "Scroll down" })
vim.keymap.set({ "n", "v" }, "<leader>os", select_prompt, { desc = "Select prompt" })

-- -----------------------------------------------------------------------------
-- Plugin: Mason & Pack
-- -----------------------------------------------------------------------------
vim.keymap.set("n", "<leader>M", "<cmd>Mason<CR>", { desc = "Open Mason Window" })
vim.keymap.set("n", "<leader>L", "<cmd>lua vim.pack.update()<CR>", { desc = "Update Plugins" })

-- -----------------------------------------------------------------------------
-- Plugin: Copilot
-- -----------------------------------------------------------------------------
vim.keymap.set("i", "<S-Tab>", 'copilot#Accept("\\<S-Tab>")', { expr = true, replace_keycodes = false })
-- -----------------------------------------------------------------------------
-- Plugin: Kanban
-- -----------------------------------------------------------------------------
vim.keymap.set("n", "<leader>K", "<cmd>Kanban<CR>", { desc = "Open Kanban Board" })
