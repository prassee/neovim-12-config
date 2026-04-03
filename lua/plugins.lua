-- =============================================================================
-- PLUGIN CONFIGURATION
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Colorscheme
-- -----------------------------------------------------------------------------
pcall(vim.cmd, "colorscheme catppuccin")

-- -----------------------------------------------------------------------------
-- Treesitter
-- -----------------------------------------------------------------------------
local ok_ts, ts_configs = pcall(require, "nvim-treesitter.configs")
if ok_ts then
	ts_configs.setup({
		ensure_installed = { "lua", "go", "python", "json", "yaml", "toml", "markdown", "bash", "rust", "typescript" },
		highlight = { enable = true, additional_vim_regex_highlighting = false },
		indent = { enable = true },
	})
end

-- -----------------------------------------------------------------------------
-- Snippets (LuaSnip + friendly-snippets)
-- -----------------------------------------------------------------------------
require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_snipmate").lazy_load()

-- -----------------------------------------------------------------------------
-- Mason & LSP Setup
-- -----------------------------------------------------------------------------
local ok_mason, mason = pcall(require, "mason")
if ok_mason then
	mason.setup()
end
local ok_mason_lsp, mason_lsp = pcall(require, "mason-lspconfig")
if ok_mason_lsp then
	mason_lsp.setup()
end
local ok_mti, mti = pcall(require, "mason-tool-installer")
if ok_mti then
	mti.setup({
		ensure_installed = {
			"lua_ls",
			"stylua",
			"pyrefly",
			"gopls",
			"yaml-language-server",
			"prettier",
			"yamlfmt",
			"shfmt",
			"tinymist",
		},
	})
end

vim.lsp.enable({ "lua_ls", "gopls", "pyrefly", "dockerls", "taplo", "jsonls", "marksman", "yamlls", "tinymist" })
vim.lsp.inlay_hint.enable(true)

-- -----------------------------------------------------------------------------
-- LSP Server Configurations
-- -----------------------------------------------------------------------------
vim.lsp.config("lua_ls", {
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
			usePlaceholders = true,
			completeUnimported = true,
			staticcheck = true,
			directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
			semanticTokens = true,
		},
	},
})

vim.lsp.config("dockerls", {
	filetypes = { "dockerfile" },
	root_markers = { "Dockerfile", "Containerfile", ".git" },
	single_file_support = true,
})

vim.lsp.config("taplo", {
	filetypes = { "toml" },
	root_markers = { "*.toml", ".git" },
	single_file_support = true,
})

vim.lsp.config("jsonls", {
	filetypes = { "json", "jsonc" },
	root_markers = { "package.json", ".git" },
	single_file_support = true,
	settings = {
		json = {
			schemas = (function()
				local ok, schemastore = pcall(require, "schemastore")
				return ok and schemastore.json.schemas() or {}
			end)(),
			validate = { enable = true },
		},
	},
})

vim.lsp.config("marksman", {
	filetypes = { "markdown", "markdown.mdx" },
	root_markers = { "README.md", ".git" },
	single_file_support = true,
})

vim.lsp.config("yamlls", {
	filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab" },
	root_markers = { ".git" },
	single_file_support = true,
	settings = {
		yaml = {
			schemas = (function()
				local ok, schemastore = pcall(require, "schemastore")
				return ok and schemastore.yaml.schemas() or {}
			end)(),
			validate = true,
			schemaStore = {
				enable = false, -- Disable built-in schemaStore to use schemastore.nvim
				url = "",
			},
		},
	},
})

vim.lsp.config("tinymist", {
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
vim.opt.completeopt = { "menu", "menuone", "noselect", "popup" }

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
		timeout_ms = 2000,
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
		["yaml.docker-compose"] = { "yamlfmt" },
		sh = { "shfmt" },
		bash = { "shfmt" },
		zsh = { "shfmt" },
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
		{ mode = "n", keys = "<LocalLeader>" },
		{ mode = "x", keys = "<LocalLeader>" },
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
		-- Environment Info hints
		{ mode = "n", keys = "<LocalLeader>ei", desc = "+Environment Info" },
		{ mode = "n", keys = "<LocalLeader>eia", desc = "Add environment info" },
		{ mode = "n", keys = "<LocalLeader>eiv", desc = "View environment info" },
		{ mode = "n", keys = "<LocalLeader>eic", desc = "Clear environment info" },
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
vim.g.gitsigns_heads = "+~_-"
require("gitsigns").setup({
	current_line_blame = false,
	current_line_blame_opts = {
		virt_text = true,
		virt_text_pos = "eol",
		delay = 300,
	},
})

-- -----------------------------------------------------------------------------
-- Neogit
-- -----------------------------------------------------------------------------
require("neogit").setup({
	commit_editor = {
		kind = "tab",
	},
	disable_insert_on_commit = true,
	commit = {
		signoff = false,
		verify_commit = vim.fn.executable("gpg") == 1,
	},
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "NeogitCommitMessage", "gitcommit" },
	callback = function()
		local opts = { buffer = true, silent = true }
		vim.keymap.set("n", "<F5>", ":wq<CR>", opts)
		vim.keymap.set("n", "<F6>", ":qa!<CR>", opts)
		vim.keymap.set("n", "<F7>", function()
			local staged_diff = vim.fn.system("git diff --cached --stat")
			if vim.v.shell_error ~= 0 then
				vim.notify("No staged changes found", vim.log.levels.WARN)
				return
			end
			local files = vim.split(staged_diff, "\n", { trimempty = true })
			local file_list = {}
			for _, f in ipairs(files) do
				if f:match("^[a-zA-Z]") and not f:match("^%d+") then
					table.insert(file_list, f)
				end
			end
			if #file_list > 5 then
				file_list = { file_list[1], file_list[2], "... (" .. (#file_list - 4) .. " more)" }
			end
			local prompt = "Based on these changes ("
				.. table.concat(file_list, ", ")
				.. "), write a concise conventional commit message (type: description)"
			vim.api.nvim_put({ prompt }, "a", true, true)
			vim.defer_fn(function()
				vim.api.nvim_feedkeys("<Tab>", "i", true)
			end, 150)
		end, { buffer = true, desc = "Generate commit message" })
	end,
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
-- Python REPL (pyrepl.nvim)
-- -----------------------------------------------------------------------------

require("pyrepl").setup({
	vim_opts = {
		hidden = true, -- start in hidden buffer
	},
	image_provider = "placeholders",
	cell_pattern = "^# %%.*$",
	python_path = "python",
	preferred_kernel = "python3",
	jupytext_hook = true,
})

-- ------
-- Agentic.nvim
-- ------
require("agentic").setup({
	-- agentic.setup expects the config table directly (not an `opts` wrapper).
	provider = "opencode-acp",
	windows = {
		position = "right", -- "right", "left", or "bottom"
		width = "40%", -- Sidebar width (position = "right" or "left")
		height = "30%", -- Panel height (position = "bottom")
	},
	-- Keybindings moved to lua/keymaps.lua to keep global mappings consistent
})
