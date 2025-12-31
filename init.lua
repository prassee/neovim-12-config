-- ============================================================================
-- LEADER & SETTINGS
-- ============================================================================
vim.g.mapleader = "\\"
vim.g.have_nerd_font = true

-- ============================================================================
-- OPTIONS
-- ============================================================================
-- Relative and absolute line numbers combined
vim.opt.number = true
vim.opt.relativenumber = false

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Cursorline
vim.opt.cursorline = true

-- Show whitespace characters
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Preview substitutions
vim.opt.inccommand = "split"

-- Text wrapping
vim.opt.wrap = true
vim.opt.breakindent = true

-- Tabstops
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

-- Window splitting
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Save undo history
vim.opt.undofile = true

-- Set the default border for all floating windows
vim.opt.winborder = "rounded"
vim.g.completion_enabled = false

-- ============================================================================
-- PACK MANAGEMENT COMMAND
-- ============================================================================
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

-- ============================================================================
-- PACK DECLARATIONS
-- ============================================================================
vim.pack.add({
	-- Core & LSP
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", name = "nvim-treesitter" },
	{ src = "https://github.com/neovim/nvim-lspconfig", name = "nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim", name = "mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim", name = "mason-lspconfig.nvim" },
	{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim", name = "mason-tool-installer.nvim" },
	{ src = "https://github.com/Saghen/blink.cmp", name = "blink.cmp" },
	{ src = "https://github.com/L3MON4D3/LuaSnip", name = "LuaSnip" },
	{ src = "https://github.com/rafamadriz/friendly-snippets", name = "friendly-snippets" },
	{ src = "https://github.com/stevearc/oil.nvim", name = "oil.nvim" },
	{ src = "https://github.com/nvim-mini/mini.pick", name = "mini.pick" },
	{ src = "https://github.com/nvim-mini/mini.clue", name = "mini.clue" },
	-- UI & Theme
	{ src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
	{ src = "https://github.com/nvim-lualine/lualine.nvim", name = "lualine.nvim" },
	-- Formatting & Linting
	{ src = "https://github.com/stevearc/conform.nvim", name = "conform.nvim" },
	-- Fuzzy Finder
	{ src = "https://github.com/ibhagwan/fzf-lua", name = "fzf-lua" },
	-- Terminal & Floating Windows
	{ src = "https://github.com/akinsho/toggleterm.nvim", name = "toggleterm.nvim" },
	-- Project Management
	{ src = "https://github.com/b0o/SchemaStore.nvim", name = "SchemaStore.nvim" },
	{ src = "https://github.com/viniciusteixeiradias/kanban.nvim", name = "kanban.nvim" },
	-- AI & Coding Assistant
	{ src = "https://github.com/NickvanDyke/opencode.nvim", name = "opencode.nvim" },
})

-- ============================================================================
-- PLUGIN CONFIGURATIONS
-- ============================================================================

-- Mason: Package manager for LSP, DAP, linters, formatters
require("mason").setup()
require("mason-lspconfig").setup()
require("mason-tool-installer").setup({
	ensure_installed = {
		"lua_ls",
		"stylua",
		"pyrefly",
		"gopls",
	},
})

-- Oil: File explorer
require("oil").setup({
	keymaps = { ["`"] = "actions.tcd" },
	columns = { "size", "mtime" },
	delete_to_trash = true,
	skip_confirm_for_simple_edits = true,
})

-- Treesitter and highlighting
vim.cmd("syntax off")

-- ============================================================================
-- LSP & DIAGNOSTICS
-- ============================================================================
-- Enable LSP servers
vim.lsp.enable({ "pyrefly", "lua_ls", "gopls", "dockerls" })
vim.lsp.inlay_hint.enable(true)

-- Diagnostic configuration
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

-- Language server configurations
vim.lsp.config("dockerls", {
	cmd = { "docker-langserver", "--stdio" },
	filetypes = { "dockerfile" },
	root_markers = { "Dockerfile", "Containerfile", ".git" },
	single_file_support = true,
})

vim.lsp.config("gopls", {
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gowork", "gotmpl", "gosum" },
	root_markers = { "go.mod", "go.work", ".git" },
	settings = {
		gopls = {
			gofumpt = true,
			usePlaceholders = true,
			completeUnimported = true,
			staticcheck = true,
			semanticTokens = true,
			directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
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
		},
	},
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

-- ============================================================================
-- COMPLETION & SNIPPETS
-- ============================================================================
-- Blink.cmp: Completion engine
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
			auto_show = false,
			draw = {
				treesitter = { "lsp" },
				columns = { { "kind_icon", "label", "label_description", gap = 1 }, { "kind" } },
			},
		},
	},
})

-- ============================================================================
-- FORMATTING & LINTING
-- ============================================================================
-- Conform: Code formatter
require("conform").setup({
	format_on_save = {
		timeout_ms = 500,
		lsp_fallback = true,
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
	},
})

-- ============================================================================
-- UI & THEME
-- ============================================================================
-- Catppuccin: Colorscheme
vim.cmd.colorscheme("catppuccin")

-- Lualine: Status line
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

-- Mini.pick: Picker for lists
require("mini.pick").setup()

-- Mini.clue: Command palette hints
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

-- ============================================================================
-- TERMINAL & FLOATING WINDOWS
-- ============================================================================
-- Toggleterm: Terminal emulator
require("toggleterm").setup({
	shade_terminals = true,
})

local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({ cmd = "lazygit", direction = "float", hidden = true })
local opencode = Terminal:new({ cmd = "opencode", direction = "float", hidden = true })
local thoth = Terminal:new({ cmd = "thoth", direction = "float", hidden = true })
local flow_tracker = Terminal:new({ cmd = "flow_state", direction = "float", hidden = true })

-- ============================================================================
-- SEARCH & FUZZY FINDING
-- ============================================================================
-- Fzf-lua: Fuzzy finder
local fzf = require("fzf-lua")
fzf.setup({
	files = {
		cmd = "git ls-files --cached --others --exclude-standard 2>/dev/null || rg --files --hidden --glob '!/.git/*'",
	},
})
fzf.register_ui_select()

-- ============================================================================
-- PROJECT MANAGEMENT
-- ============================================================================
-- Kanban: Task board
require("kanban").setup({
	file = {
		path = nil,
		name = "TODO.md",
		create_if_missing = true,
	},
	default_columns = { "Backlog", "In Progress", "Done" },
	window = {
		width = 0.8,
		height = 0.8,
		border = "rounded",
	},
	highlights = {
		column_header = { bold = true, fg = "#888888" },
		column_header_active = { bold = true, fg = "#ffffff", bg = "#3a3a3a" },
		task = { default = true },
		task_active = { fg = "#000000", bg = "#7dd3fc", bold = true },
		task_done = { strikethrough = true, fg = "#666666" },
		separator = { fg = "#444444" },
	},
	auto_refresh_buffers = true,
	on_complete_move_to = "Done",
})

-- ============================================================================
-- AI & CODING ASSISTANT
-- ============================================================================
-- OpenCode: AI assistant integration
-- (Configuration handled through keymaps below)

-- ============================================================================
-- AUTOCOMMANDS
-- ============================================================================
-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Enable treesitter for file types
vim.api.nvim_create_autocmd("FileType", {
	desc = "Start treesitter for current file type",
	callback = function()
		pcall(vim.treesitter.start)
	end,
})

-- LSP attach handler
vim.api.nvim_create_autocmd("LspAttach", {
	desc = "Configure LSP completion on attach",
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_completion) then
			vim.opt.completeopt = { "menu", "menuone", "noselect" }
			vim.lsp.completion.enable(false, client.id, ev.buf)
			vim.keymap.set("i", "<C-Space>", function()
				vim.lsp.completion.get()
			end)
		end
	end,
})

-- ============================================================================
-- KEYBINDINGS
-- ============================================================================
local opts = { noremap = true, silent = true }
local opencode = require("opencode")

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

local function toggle_lazygit()
	lazygit:toggle()
end

local function toggle_thoth()
	thoth:toggle()
end

local function toggle_flow_tracker()
	flow_tracker:toggle()
end

local function toggle_opencode_terminal()
	opencode:toggle()
end
-- === File Management ===
vim.keymap.set({ "n", "i" }, "<leader>s", "<Esc><cmd>w<CR>", { desc = "Save file" })
vim.keymap.set("n", "<leader>q", ":wqall<CR>", { desc = "Quit all" })
vim.keymap.set("n", "<leader>r", "<cmd>checktime<CR>", { desc = "Refresh file" })
-- === Search & Navigation ===
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })
-- === Line Navigation ===
vim.keymap.set({ "n", "i" }, "<leader>a", "<Esc>^i<Esc>", { desc = "Beginning of line" })
vim.keymap.set({ "n", "i" }, "<leader>e", "<End>", { desc = "End of line" })
-- === Jump List Navigation ===
vim.keymap.set("n", "<M-left>", "g;", { desc = "Older cursor position" })
vim.keymap.set("n", "<M-right>", "g,", { desc = "Newer cursor position" })
-- === Buffer Navigation ===
vim.keymap.set("n", "<M-S-left>", "<Esc>:bprevious<Esc>", { desc = "Previous buffer" })
vim.keymap.set("n", "<M-S-right>", "<Esc>:bnext<Esc>", { desc = "Next buffer" })
-- === Window Management ===
vim.keymap.set("n", "<leader>g<left>", "<C-w><C-h>", { desc = "Focus left" })
vim.keymap.set("n", "<leader>g<down>", "<C-w><C-j>", { desc = "Focus down" })
vim.keymap.set("n", "<leader>g<up>", "<C-w><C-k>", { desc = "Focus up" })
vim.keymap.set("n", "<leader>g<right>", "<C-w><C-l>", { desc = "Focus right" })
vim.keymap.set("n", "<leader>Sv", ":vsplit<CR>", { desc = "Vertical split" })
vim.keymap.set("n", "<leader>Sh", ":split<CR>", { desc = "Horizontal split" })
vim.keymap.set("n", "<leader>Sc", "<cmd>close<CR>", { desc = "Close split" })
vim.keymap.set("n", "<leader>So", "<cmd>only<CR>", { desc = "Only this split" })
-- === Text Editing ===
vim.keymap.set("n", "<M-down>", ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<M-up>", ":m .-2<CR>==", { desc = "Move line up" })
-- === Terminal ===
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("n", "<leader>t", ":ToggleTerm direction=float<CR>", opts)
-- === Terminal Apps ===
vim.keymap.set("n", "<leader>G", toggle_lazygit, { desc = "Lazygit" })
vim.keymap.set("n", "<leader>T", toggle_thoth, { desc = "Thoth" })
vim.keymap.set("n", "<leader>H", toggle_flow_tracker, { desc = "Flow Tracker" })
vim.keymap.set("n", "<leader>O", toggle_opencode_terminal, { desc = "OpenCode Terminal" })
-- === Fzf-lua (Fuzzy Finder) ===
vim.keymap.set("n", "<leader>ff", fzf.files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fF", fzf.files, { desc = "Find files (cwd)" })
vim.keymap.set("n", "<leader>fG", fzf.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", fzf.buffers, { desc = "Buffers" })
vim.keymap.set("n", "<leader>fr", fzf.lsp_references, { desc = "LSP references" })
vim.keymap.set("n", "<leader>fD", fzf.lsp_definitions, { desc = "LSP definitions" })
vim.keymap.set("n", "<leader>fca", fzf.lsp_code_actions, { desc = "Code actions" })
vim.keymap.set("n", "<leader>fds", fzf.lsp_document_symbols, { desc = "Document symbols" })
vim.keymap.set("n", "<leader>fws", fzf.lsp_workspace_symbols, { desc = "Workspace symbols" })
vim.keymap.set("n", "<leader>fh", fzf.help_tags, { desc = "Help tags" })
vim.keymap.set("n", "<leader>fR", vim.lsp.buf.rename, { desc = "LSP rename" })
vim.keymap.set("n", "<leader>fdd", ":FzfLua lsp_document_diagnostics<CR>", { desc = "Document diagnostics" })
vim.keymap.set("n", "<leader>fwd", ":FzfLua lsp_workspace_diagnostics<CR>", { desc = "Workspace diagnostics" })
vim.keymap.set("n", "<leader>fA", ":FzfLua lsp_code_actions<CR>", { desc = "Code actions" })
vim.keymap.set("n", "<leader>fgs", fzf.git_status, { desc = "Git status" })
vim.keymap.set("n", "<leader>fgc", fzf.git_commits, { desc = "Git commits" })
vim.keymap.set("n", "<leader>fC", fzf.commands, { desc = "Commands" })
-- === OpenCode (AI Assistant) ===
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
-- === Tools & Utilities ===
vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "Oil file explorer" })
vim.keymap.set("n", "<leader>M", "<cmd>Mason<CR>", { desc = "Mason" })
vim.keymap.set("n", "<leader>L", "<cmd>lua vim.pack.update()<CR>", { desc = "Update plugins" })
vim.keymap.set("n", "<leader>y", "<cmd>%y+<CR>", { desc = "Copy buffer to clipboard" })
vim.keymap.set({ "n", "v", "i" }, "<C-a>", "<Esc>ggVG", { desc = "Select all" })
