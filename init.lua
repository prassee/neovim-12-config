vim.g.mapleader = "\\"
vim.g.have_nerd_font = true

-- options
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

vim.pack.add({
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/stevearc/oil.nvim",
	"https://github.com/nvim-mini/mini.pick",
	"https://github.com/nvim-mini/mini.clue",
	"https://github.com/Saghen/blink.cmp",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/mason-org/mason-lspconfig.nvim",
	"https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
	"https://github.com/L3MON4D3/LuaSnip",
	"https://github.com/rafamadriz/friendly-snippets",
})

vim.pack.add({
	{ src = "https://github.com/b0o/SchemaStore.nvim" },
})

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

-- disable mouse popup yet keep mouse enabled
--vim.cmd [[
--  aunmenu PopUp
--  autocmd! nvim.popupmenu
-- ]]

-- Only highlight with treesitter
vim.cmd("syntax off")

require("oil").setup({
	keymaps = { ["`"] = "actions.tcd" },
	columns = { "size", "mtime" },
	delete_to_trash = true,
	skip_confirm_for_simple_edits = true,
})

vim.lsp.enable({ "pyrefly", "lua_ls", "gopls", "dockerls" })
vim.lsp.inlay_hint.enable(true)

vim.diagnostic.config({
	virtual_lines = true,
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

vim.lsp.config("dockerls", {
	cmd = { "docker-langserver", "--stdio" },
	filetypes = { "dockerfile" },
	root_markers = { "Dockerfile", "Containerfile", ".git" },
	single_file_support = true,
})

vim.lsp.config("gopls", {
	cmd = { "gopls" }, -- Command to start the language server
	filetypes = { "go", "gomod", "gowork", "gotmpl", "gosum" }, -- File types that this server will handle
	root_markers = { "go.mod", "go.work", ".git" }, -- Markers to identify the root of the project
	settings = { -- Settings for the language server
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

	-- Filetypes to automatically attach to.
	filetypes = { "lua" },

	-- Sets the "root directory" to the parent directory of the file in the
	-- current buffer that contains either a ".luarc.json" or a
	-- ".luarc.jsonc" file. Files that share a root directory will reuse
	-- the connection to the same LSP server.
	-- Nested lists indicate equal priority, see |vim.lsp.Config|.
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
				-- Get the language server to recognize the `vim` global
				globals = { "vim" },
			},
		},
	},
})

-- require("luasnip.loaders.from_vscode").lazy_load()
require("blink.cmp").setup({
	keymap = {
		["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
		["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
		["<CR>"] = { "accept", "fallback" },
		["<Esc>"] = { "hide", "fallback" },
		["<PageUp>"] = { "scroll_documentation_up", "fallback" },
		["<PageDown>"] = { "scroll_documentation_down", "fallback" },
	},
	-- sources = { "lsp", "path", "snippets", "buffer" },
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
})

-- Autocommands

-- highlight while yanking
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	callback = function()
		pcall(vim.treesitter.start)
	end,
})

vim.api.nvim_create_autocmd("LspAttach", {
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

-- Diagnostics
vim.diagnostic.config({
	-- Use the default configuration
	-- virtual_lines = true

	-- Alternatively, customize specific options
	virtual_lines = {
		-- Only show virtual line diagnostics for the current cursor line
		current_line = true,
	},
})

require("mini.pick").setup()
require("mini.clue").setup({
	triggers = {
		-- Leader triggers
		{ mode = "n", keys = "<Leader>" },
		{ mode = "x", keys = "<Leader>" },
		-- Built-in completion
		{ mode = "i", keys = "<C-x>" },

		-- `g` key
		{ mode = "n", keys = "g" },
		{ mode = "x", keys = "g" },

		-- Marks
		{ mode = "n", keys = "'" },
		{ mode = "n", keys = "`" },
		{ mode = "x", keys = "'" },
		{ mode = "x", keys = "`" },

		-- Registers
		{ mode = "n", keys = '"' },
		{ mode = "x", keys = '"' },
		{ mode = "i", keys = "<C-r>" },
		{ mode = "c", keys = "<C-r>" },

		-- Window commands
		{ mode = "n", keys = "<C-w>" },

		-- `z` key
		{ mode = "n", keys = "z" },
		{ mode = "x", keys = "z" },
	},
})
vim.keymap.set("n", "<leader>ff", ":Pick files<CR>")

vim.pack.add({
	{ src = "https://github.com/catppuccin/nvim.git", name = "catppuccin" },
})
vim.cmd.colorscheme("catppuccin")

--: conform
vim.pack.add({
	{ src = "https://github.com/stevearc/conform.nvim" },
})
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

--: lualine
vim.pack.add({
	{ src = "https://github.com/nvim-lualine/lualine.nvim" },
})
require("lualine").setup({
	options = {
		theme = "auto",
		-- component_separators = { left = "", right = "" },
		-- section_separators = { left = "", right = "" },
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
--:

--:
-- Toggle Terminal
vim.pack.add({
	{
		src = "https://github.com/akinsho/toggleterm.nvim",
	},
})

require("toggleterm").setup({
	shade_terminals = true,
})

local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({ cmd = "lazygit", direction = "float", hidden = true })
local opencode = Terminal:new({ cmd = "opencode", direction = "float", hidden = true })
local thoth = Terminal:new({ cmd = "thoth", direction = "float", hidden = true })
local flow_tracker = Terminal:new({ cmd = "flow_state", direction = "float", hidden = true })

-- 4. Keybindings
local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<leader>G", function()
	lazygit:toggle()
end, { desc = "Lazygit", unpack(opts) })

vim.keymap.set("n", "<leader>T", function()
	thoth:toggle()
end, { desc = "Thoth", unpack(opts) })

vim.keymap.set("n", "<leader>H", function()
	flow_tracker:toggle()
end, { desc = "Flow Tracker", unpack(opts) })

vim.keymap.set("n", "<leader>O", function()
	opencode:toggle()
end, { desc = "OpenCode", unpack(opts) })

vim.keymap.set("n", "<leader>t", ":ToggleTerm direction=float<CR>", opts)

--:

--: Fzf lua
vim.pack.add({
	{ src = "https://github.com/ibhagwan/fzf-lua" },
})
local fzf = require("fzf-lua")
fzf.setup({
	files = {
		cmd = "git ls-files --cached --others --exclude-standard 2>/dev/null || rg --files --hidden --glob '!/.git/*'",
	},
})
fzf.register_ui_select()
vim.keymap.set("n", "<leader>ff", fzf.files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fF", function()
	require("fzf-lua").global()
end, { desc = "Find files (cwd)" })
vim.keymap.set("n", "<leader>fG", fzf.live_grep, { desc = "Grep" })
vim.keymap.set("n", "<leader>fb", fzf.buffers, { desc = "Buffers" })
vim.keymap.set("n", "<leader>fr", fzf.lsp_references, { desc = "LSP References" })
vim.keymap.set("n", "<leader>fD", fzf.lsp_definitions, { desc = "LSP Definitions" })
vim.keymap.set("n", "<leader>fca", fzf.lsp_code_actions, { desc = "LSP Code Actions" })
vim.keymap.set("n", "<leader>fs", fzf.lsp_document_symbols, { desc = "LSP Document Symbols" })
vim.keymap.set("n", "<leader>fw", fzf.lsp_workspace_symbols, { desc = "LSP Workspace Symbols" })
vim.keymap.set("n", "<leader>fh", fzf.help_tags, { desc = "Help Tags" })
vim.keymap.set("n", "<leader>fR", vim.lsp.buf.rename, { desc = "LSP rename" })
-- show workspace diagnostics
vim.keymap.set("n", "<leader>fdd", ":FzfLua lsp_document_diagnostics<CR>", { desc = "LSP Workspace Diagnostics" })
vim.keymap.set("n", "<leader>fwd", ":FzfLua lsp_workspace_diagnostics<CR>", { desc = "LSP Workspace Diagnostics" })

vim.keymap.set("n", "<leader>fA", ":FzfLua lsp_code_actions<CR>", { desc = "LSP Code Actions" })
-- configure keymap to open fzf-lua's git status
vim.keymap.set("n", "<leader>fgs", fzf.git_status, { desc = "Git Status" })
vim.keymap.set("n", "<leader>fgc", fzf.git_commits, { desc = "Git Commits" })
-- keymap to list all commands
vim.keymap.set("n", "<leader>fC", fzf.commands, { desc = "Commands" })
--:

--: OpenCode
vim.pack.add({
	{ src = "https://github.com/NickvanDyke/opencode.nvim" },
})
vim.keymap.set("n", "<leader>ot", function()
	require("opencode").toggle()
end, { desc = "Toggle embedded" })
vim.keymap.set("n", "<leader>oa", function()
	require("opencode").ask("@cursor: ")
end, { desc = "Ask about this" })
vim.keymap.set("v", "<leader>oa", function()
	require("opencode").ask("@selection: ")
end, { desc = "Ask about selection" })
vim.keymap.set("n", "<leader>o+", function()
	require("opencode").prompt("@buffer", { append = true })
end, { desc = "Add buffer to prompt" })
vim.keymap.set("v", "<leader>o+", function()
	require("opencode").prompt("@selection", { append = true })
end, { desc = "Add selection to prompt" })
vim.keymap.set("n", "<leader>oe", function()
	require("opencode").prompt("Explain @cursor and its context")
end, { desc = "Explain this code" })
vim.keymap.set("n", "<leader>on", function()
	require("opencode").command("session_new")
end, { desc = "New session" })
vim.keymap.set("n", "<S-C-u>", function()
	require("opencode").command("messages_half_page_up")
end, { desc = "Messages half page up" })
vim.keymap.set("n", "<S-C-d>", function()
	require("opencode").command("messages_half_page_down")
end, { desc = "Messages half page down" })
vim.keymap.set({ "n", "v" }, "<leader>os", function()
	require("opencode").select()
end, { desc = "Select prompt" })

--:

--:
-- Keymaps
-- Saving and Quitting
vim.keymap.set({ "n", "i" }, "<leader>s", "<Esc><cmd>w<CR>", { desc = "Save" })
vim.keymap.set("n", "<leader>q", ":wqall<CR>", { desc = "Quit" })
vim.keymap.set("n", "<leader>r", "<cmd>checktime<CR>", { desc = "Refresh file if modified outside" })

-- Search
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
-- Navigation: Lines
vim.keymap.set({ "n", "i" }, "<leader>a", "<Esc>^i<Esc>", { desc = "Go to beginning of line" })
vim.keymap.set({ "n", "i" }, "<leader>e", "<End>", { desc = "Go to end of line" })

-- Navigation: Jumplist
vim.keymap.set("n", "<M-left>", "g;", { desc = "Go to older cursor position" })
vim.keymap.set("n", "<M-right>", "g,", { desc = "Go to newer cursor position" })

-- Navigation: Buffers
vim.keymap.set("n", "<M-S-left>", "<Esc>:bprevious<Esc>", { desc = "Go to previous visited buffer" })
vim.keymap.set("n", "<M-S-right>", "<Esc>:bnext<Esc>", { desc = "Go to next visited buffer" })

-- Window Management
vim.keymap.set("n", "<leader>g<left>", "<C-w><C-h>", { desc = "Move focus left" })
vim.keymap.set("n", "<leader>g<down>", "<C-w><C-j>", { desc = "Move focus down" })
vim.keymap.set("n", "<leader>g<up>", "<C-w><C-k>", { desc = "Move focus up" })
vim.keymap.set("n", "<leader>g<right>", "<C-w><C-l>", { desc = "Move focus right" })
vim.keymap.set("n", "<leader>Sv", ":vsplit<CR>", { desc = "Vertical Split" })
vim.keymap.set("n", "<leader>Sh", ":split<CR>", { desc = "Horizontal Split" })
vim.keymap.set("n", "<leader>Sc", "<cmd>close<CR>", { desc = "Close Split" })
vim.keymap.set("n", "<leader>So", "<cmd>only<CR>", { desc = "Keep Only This Split" })

-- Editing: Move Lines
vim.keymap.set("n", "<M-down>", ":m .+1<CR>==", { desc = "Move line up" }) -- move line up(n)
vim.keymap.set("n", "<M-up>", ":m .-2<CR>==", { desc = "Move line down" }) -- move line down(n)

-- Terminal
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Tools / Plugins
vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "Oil File Explorer" })
vim.keymap.set("n", "<leader>M", "<cmd>Mason<CR>", { desc = "Open [M]ason Window" })
vim.keymap.set("n", "<leader>L", "<cmd>lua vim.pack.update()<CR>", { desc = "Open [L]azy" })
vim.keymap.set("n", "<leader>y", "<cmd>%y+<CR>", { desc = "Yank entire buffer to system clipboard" })
vim.keymap.set({ "n", "v", "i" }, "<C-a>", "<Esc>ggVG", { desc = "Select all text" })
--:
--
