-- =============================================================================
-- PLUGIN CONFIGURATION
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
		"tinymist",
	},
})

vim.lsp.enable({ "lua_ls", "gopls", "pyrefly", "dockerls", "taplo", "jsonls", "marksman", "yamlls", "tinymist" })
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

vim.lsp.config("tinymist", {
	cmd = { "tinymist" },
	filetypes = { "typst" },
	root_markers = { ".git", "main.typ" },
	single_file_support = true,
	settings = {
		formatterMode = "typstfmt",
	},
})

-- -----------------------------------------------------------------------------
-- Completion (blink.cmp)
-- -----------------------------------------------------------------------------
vim.opt.completeopt = { "menu", "menuone", "noselect", "popup" } -- enable popup completion for CopilotChat

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

-- Ensure CopilotChat prompt buffers get popup completion
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "copilot-*",
	callback = function()
		vim.opt_local.completeopt = { "menu", "menuone", "noselect", "popup" }
	end,
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
	clues = {
		-- Surround hints
		{ mode = "n", keys = "gsa", desc = "Add surrounding" },
		{ mode = "n", keys = "gsd", desc = "Delete surrounding" },
		{ mode = "n", keys = "gsr", desc = "Replace surrounding" },
		{ mode = "n", keys = "gsf", desc = "Find surrounding (right)" },
		{ mode = "n", keys = "gsF", desc = "Find surrounding (left)" },
		{ mode = "n", keys = "gsh", desc = "Highlight surrounding" },
		{ mode = "n", keys = "gsn", desc = "Update n_lines" },
		{ mode = "x", keys = "gsa", desc = "Add surrounding" },
		-- Typst Preview hints
		{ mode = "n", keys = "<Leader>pt", desc = "+Typst Preview" },
		{ mode = "n", keys = "<Leader>ptp", desc = "Typst preview" },
		{ mode = "n", keys = "<Leader>pts", desc = "Typst preview stop" },
		{ mode = "n", keys = "<Leader>ptt", desc = "Typst preview toggle" },
		-- Opencode hints
		{ mode = "n", keys = "<Leader>o", desc = "+Opencode" },
		{ mode = "n", keys = "<Leader>oa", desc = "Ask opencode" },
		{ mode = "n", keys = "<Leader>os", desc = "Select opencode action" },
		{ mode = "n", keys = "<Leader>ot", desc = "Toggle opencode" },
		{ mode = "n", keys = "<Leader>oo", desc = "Opencode operator" },
		{ mode = "n", keys = "<Leader>ool", desc = "Opencode line" },
		{ mode = "n", keys = "<Leader>ou", desc = "Scroll opencode up" },
		{ mode = "n", keys = "<Leader>od", desc = "Scroll opencode down" },
	},
})

-- -----------------------------------------------------------------------------
-- Surround (mini.surround)
-- -----------------------------------------------------------------------------
require("mini.surround").setup({
	-- Use 'gs' prefix to avoid conflict with 's' (substitute) in visual mode
	mappings = {
		add = "gsa", -- Add surrounding (gsa in visual, gsaiw( in normal)
		delete = "gsd", -- Delete surrounding (gsd))
		replace = "gsr", -- Replace surrounding (gsr)})
		find = "gsf", -- Find surrounding (to the right)
		find_left = "gsF", -- Find surrounding (to the left)
		highlight = "gsh", -- Highlight surrounding
		update_n_lines = "gsn", -- Update n_lines
	},
})

-- -----------------------------------------------------------------------------
-- Terminal (toggleterm)
-- -----------------------------------------------------------------------------
require("toggleterm").setup({
	shade_terminals = true,
})

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
-- Typst Preview
-- -----------------------------------------------------------------------------

require("typst-preview").setup({
	dependencies_bin = {
		["tinymist"] = "tinymist", -- Use Mason-installed tinymist
	},
})
-- -----------------------------------------------------------------------------
-- snacks.nvim (dependency for opencode.nvim ask/select/terminal)
-- -----------------------------------------------------------------------------
require("snacks").setup({
	input = {},
	picker = {},
	terminal = {},
})

-- -----------------------------------------------------------------------------
-- opencode.nvim configuration for Neovim 0.12+
-- See: https://github.com/nickjvandyke/opencode.nvim
-- -----------------------------------------------------------------------------
vim.o.autoread = true -- Required for opts.events.reload

---@type opencode.Opts
vim.g.opencode_opts = {
	-- Configuration options: see lua/opencode/config.lua
	provider = {
		enabled = "snacks", -- Use snacks provider (recommended with snacks.nvim)
	},
}

-- -----------------------------------------------------------------------------
-- Python REPL (pyrepl.nvim)
-- -----------------------------------------------------------------------------

require("image").setup({
	backend = "sixel",
})

require("pyrepl").setup({
	vim_opts = {
		hidden = true, -- start in hidden buffer
	},
	image_provider = "image",
	cell_pattern = "^# %%%%.*$",
	python_path = "python",
	preferred_kernel = "python3",
	jupytext_hook = true,
})
