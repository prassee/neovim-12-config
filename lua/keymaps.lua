-- =============================================================================
-- KEYMAPS
-- =============================================================================
-- Keymap Prefix Reference:
--   <leader>b  = Buffers
--   <leader>f  = Find (fzf-lua search)
--   <leader>g  = Git (gitsigns + fzf git)
--   <leader>l  = LSP actions
--   <leader>p  = Plugins (Mason, Pack)
--   <leader>t  = Terminal / Tools
--   <leader>w  = Window management

local fzf = require("fzf-lua")
local Terminal = require("toggleterm.terminal").Terminal

-- =============================================================================
-- Terminal Instances
-- =============================================================================
local thoth = Terminal:new({ cmd = "thoth", direction = "float", hidden = true })

-- =============================================================================
-- Helper Functions
-- =============================================================================

-- Keymap helper to reduce boilerplate
local function map(mode, lhs, rhs, opts)
	opts = opts or {}
	if not opts.desc then
		error("Keymap for " .. lhs .. " requires a description")
	end
	vim.keymap.set(mode, lhs, rhs, opts)
end

-- Format buffer
local function format_buffer()
	require("conform").format()
end

-- Terminal toggles
local function toggle_thoth()
	thoth:toggle()
end

-- =============================================================================
-- General: Saving & Quitting
-- =============================================================================
map("n", "<leader>s", "<Esc><cmd>w<CR>", { desc = "Save", nowait = true })
map("n", "<leader>q", ":wqall<CR>", { desc = "Quit all" })
map("n", "<leader>S", "<cmd>source %<CR>", { desc = "Source current file" })
map("n", "<leader>Q", ":qall!<CR>", { desc = "Force quit all" })
map("n", "<leader>r", "<cmd>checktime<CR>", { desc = "Refresh file" })

-- =============================================================================
-- General: Search
-- =============================================================================
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- =============================================================================
-- General: Line Navigation & Clipboard
-- =============================================================================
local line_nav = {
	{ "n", "<leader>a", "^", "Go to line start" },
	{ "n", "<leader>e", "$", "Go to line end" },
	{ "i", "<C-a>", "<C-o>^", "Go to line start" },
	{ "i", "<C-e>", "<End>", "Go to line end" },
}
for _, km in ipairs(line_nav) do
	map(km[1], km[2], km[3], { desc = km[4] })
end

-- =============================================================================
-- General: Jumplist Navigation
-- =============================================================================
local jumplist_nav = {
	{ "<M-left>", "g;", "Older cursor position" },
	{ "<M-right>", "g,", "Newer cursor position" },
	{ "<leader>.", "`.", "Last edit location" },
}
for _, km in ipairs(jumplist_nav) do
	map("n", km[1], km[2], { desc = km[3] })
end

-- =============================================================================
-- General: Line Movement
-- =============================================================================
local line_move = {
	{ "n", "<M-down>", ":m .+1<CR>==", "Move line down" },
	{ "n", "<M-up>", ":m .-2<CR>==", "Move line up" },
	{ "v", "<M-down>", ":m '>+1<CR>gv=gv", "Move selection down" },
	{ "v", "<M-up>", ":m '<-2<CR>gv=gv", "Move selection up" },
}
for _, km in ipairs(line_move) do
	map(km[1], km[2], km[3], { desc = km[4] })
end

-- =============================================================================
-- General: Clipboard
-- =============================================================================
map("n", "<leader>y", "<cmd>%y+<CR>", { desc = "Yank buffer to clipboard" })
map({ "n", "v" }, "<C-a>", "<Esc>ggVG", { desc = "Select all" })

-- =============================================================================
-- Buffers: <leader>b
-- =============================================================================
local buffer_maps = {
	{ "bb", fzf.buffers, "List buffers" },
	{ "bd", "<cmd>bdelete<CR>", "Delete buffer" },
	{ "bn", "<cmd>bnext<CR>", "Next buffer" },
	{ "bp", "<cmd>bprevious<CR>", "Previous buffer" },
}
for _, km in ipairs(buffer_maps) do
	map("n", "<leader>" .. km[1], km[2], { desc = km[3] })
end

-- Buffer navigation with Alt+Shift+arrows
map("n", "<M-S-left>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<M-S-right>", "<cmd>bnext<CR>", { desc = "Next buffer" })

-- =============================================================================
-- Find: <leader>f (fzf-lua)
-- =============================================================================
local find_maps = {
	{ "ff", fzf.files, "Find files" },
	{ "fg", fzf.live_grep, "Find grep" },
	{ "fw", fzf.grep_cword, "Find word under cursor" },
	{ "fh", fzf.help_tags, "Find help" },
	{ "fc", fzf.commands, "Find commands" },
	{ "fr", fzf.oldfiles, "Find recent files" },
	{ "f/", fzf.blines, "Find in buffer" },
}
for _, km in ipairs(find_maps) do
	map("n", "<leader>" .. km[1], km[2], { desc = km[3] })
end

-- =============================================================================
-- Git: <leader>g (unified gitsigns + fzf git)
-- =============================================================================
local git_fzf_maps = {
	{ "gs", fzf.git_status, "Git status" },
	{ "gC", fzf.git_commits, "Git commits" },
	{ "gH", fzf.git_bcommits, "Git buffer commits" },
	{ "gb", fzf.git_branches, "Git branches" },
}
for _, km in ipairs(git_fzf_maps) do
	map("n", "<leader>" .. km[1], km[2], { desc = km[3] })
end

local git_hunk_maps = {
	{ "gp", "<cmd>Gitsigns preview_hunk<CR>", "Preview hunk" },
	{ "gr", "<cmd>Gitsigns reset_hunk<CR>", "Reset hunk" },
	{ "gR", "<cmd>Gitsigns reset_buffer<CR>", "Reset buffer" },
	{ "gd", "<cmd>Gitsigns diffthis<CR>", "Diff this" },
	{ "gl", "<cmd>Gitsigns toggle_current_line_blame<CR>", "Toggle line blame" },
	{ "gB", "<cmd>Gitsigns blame<CR>", "Blame buffer" },
}
for _, km in ipairs(git_hunk_maps) do
	map("n", "<leader>" .. km[1], km[2], { desc = km[3] })
end

-- Hunk navigation (standard [ ] motion)
map("n", "]h", "<cmd>Gitsigns next_hunk<CR>", { desc = "Next hunk" })
map("n", "[h", "<cmd>Gitsigns prev_hunk<CR>", { desc = "Previous hunk" })

-- Neogit
map("n", "<leader>ng", "<cmd>Neogit<CR>", { desc = "Open Neogit" })

-- =============================================================================
-- LSP: <leader>l
-- =============================================================================
local lsp_goto_maps = {
	{ "lgd", fzf.lsp_definitions, "Definition" },
	{ "lgD", fzf.lsp_declarations, "Declaration" },
	{ "lgi", fzf.lsp_implementations, "Implementation" },
	{ "lgt", fzf.lsp_typedefs, "Type definition" },
}
for _, km in ipairs(lsp_goto_maps) do
	map("n", "<leader>" .. km[1], km[2], { desc = km[3] })
end

local lsp_find_maps = {
	{ "lr", fzf.lsp_references, "References" },
	{ "ls", fzf.lsp_document_symbols, "Document symbols" },
	{ "lS", fzf.lsp_workspace_symbols, "Workspace symbols" },
}
for _, km in ipairs(lsp_find_maps) do
	map("n", "<leader>" .. km[1], km[2], { desc = km[3] })
end

local lsp_action_maps = {
	{ "la", fzf.lsp_code_actions, "Code actions" },
	{ "ln", vim.lsp.buf.rename, "Rename symbol" },
	{ "lh", vim.lsp.buf.hover, "Hover documentation" },
	{ "lf", format_buffer, "Format buffer" },
	{ "lr", vim.lsp.codelens.run, "Run codelens" },
	{ "lR", vim.lsp.codelens.refresh, "Refresh codelens" },
}
for _, km in ipairs(lsp_action_maps) do
	map("n", "<leader>" .. km[1], km[2], { desc = km[3] })
end

-- Diagnostics: <leader>lx
local lsp_diag_maps = {
	{ "lxd", fzf.diagnostics_document, "Document diagnostics" },
	{ "lxw", fzf.diagnostics_workspace, "Workspace diagnostics" },
}
for _, km in ipairs(lsp_diag_maps) do
	map("n", "<leader>" .. km[1], km[2], { desc = km[3] })
end

map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })

-- =============================================================================
-- Window: <leader>w
-- =============================================================================
local window_cmd_maps = {
	{ "wv", "<cmd>vsplit<CR>", "Split vertical" },
	{ "ws", "<cmd>split<CR>", "Split horizontal" },
	{ "wc", "<cmd>close<CR>", "Close window" },
	{ "wo", "<cmd>only<CR>", "Close other windows" },
	{ "w=", "<C-w>=", "Balance windows" },
}
for _, km in ipairs(window_cmd_maps) do
	map("n", "<leader>" .. km[1], km[2], { desc = km[3] })
end

-- Window navigation (hjkl and arrow keys map to same commands)
local nav_keys = {
	{ { "h", "<left>" }, "<C-w>h", "Go left" },
	{ { "j", "<down>" }, "<C-w>j", "Go down" },
	{ { "k", "<up>" }, "<C-w>k", "Go up" },
	{ { "l", "<right>" }, "<C-w>l", "Go right" },
}
for _, map_group in ipairs(nav_keys) do
	for _, key in ipairs(map_group[1]) do
		map("n", "<leader>w" .. key, map_group[2], { desc = map_group[3] })
	end
end

-- =============================================================================
-- Terminal: <leader>t
-- =============================================================================
local terminal_maps = {
	{ "tt", ":ToggleTerm direction=float<CR>", "Toggle terminal" },
	{ "th", ":ToggleTerm direction=horizontal<CR>", "Terminal horizontal" },
	{ "tv", ":ToggleTerm direction=vertical<CR>", "Terminal vertical" },
	{ "to", toggle_thoth, "Thoth" },
}
for _, km in ipairs(terminal_maps) do
	map("n", "<leader>" .. km[1], km[2], { desc = km[3] })
end

map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- =============================================================================
-- Plugins: <leader>p
-- =============================================================================
local plugin_maps = {
	{ "pm", "<cmd>Mason<CR>", "Mason" },
	{ "pu", "<cmd>lua vim.pack.update()<CR>", "Update plugins" },
	{
		"pd",
		function()
			vim.ui.input({ prompt = "Plugin to delete: " }, function(input)
				if input then
					vim.pack.delete(input)
				end
			end)
		end,
		"Delete plugin",
	},
}
for _, km in ipairs(plugin_maps) do
	map("n", "<leader>" .. km[1], km[2], { desc = km[3] })
end

-- =============================================================================
-- PyREPL
-- =============================================================================
local pyrepl = require("pyrepl")
map("n", "<leader>jo", pyrepl.open_repl, { desc = "Open REPL" })
map("n", "<leader>jh", pyrepl.hide_repl, { desc = "Hide REPL" })
map("n", "<leader>jc", pyrepl.close_repl, { desc = "Close REPL" })
map("n", "<leader>ji", pyrepl.open_image_history, { desc = "Open image history" })
map({ "n", "t" }, "<C-j>", pyrepl.toggle_repl_focus, { desc = "Toggle REPL focus" })

-- send commands
map("n", "<leader>jb", pyrepl.send_buffer, { desc = "Send buffer to REPL" })
map("n", "<leader>jl", pyrepl.send_cell, { desc = "Send cell to REPL" })
map("v", "<leader>jv", pyrepl.send_visual, { desc = "Send selection to REPL" })

-- utility commands
map("n", "<leader>jp", pyrepl.step_cell_backward, { desc = "Step cell backward" })
map("n", "<leader>jn", pyrepl.step_cell_forward, { desc = "Step cell forward" })
map("n", "<leader>je", pyrepl.export_to_notebook, { desc = "Export to notebook" })
map("n", "<leader>js", ":PyreplInstall<CR>", { desc = "Install Pyrepl dependencies" })

-- =============================================================================
-- File Explorer: Oil
-- =============================================================================
map("n", "-", "<cmd>Oil<cr>", { desc = "File explorer (Oil)" })

-- =============================================================================
-- Agentic: <leader>m (keeps <leader>a for line navigation)
-- =============================================================================
local agentic_maps = {
	-- { modes, suffix, rhs, description }
	{
		{ "n", "v", "i" },
		"ma",
		function()
			require("agentic").toggle()
		end,
		"Toggle Agentic Chat",
	},
	{
		{ "n", "v" },
		"mc",
		function()
			require("agentic").add_selection_or_file_to_context()
		end,
		"Add selection/file to Agentic context",
	},
	{
		{ "n", "v", "i" },
		"mn",
		function()
			require("agentic").new_session()
		end,
		"New Agentic session",
	},
	{
		"n",
		"mr",
		function()
			require("agentic").restore_session()
		end,
		"Restore Agentic session",
	},
	{
		"n",
		"md",
		function()
			require("agentic").add_current_line_diagnostics()
		end,
		"Add current line diagnostics to Agentic",
	},
	{
		"n",
		"mD",
		function()
			require("agentic").add_buffer_diagnostics()
		end,
		"Add buffer diagnostics to Agentic",
	},
	{
		"n",
		"mf",
		function()
			require("agentic").add_file()
		end,
		"Add current file to Agentic context",
	},
	{
		"n",
		"ms",
		function()
			require("agentic").switch_provider()
		end,
		"Switch Agentic provider",
	},
	{
		"n",
		"mR",
		function()
			require("agentic").rotate_layout()
		end,
		"Rotate Agentic layout",
	},
	{
		"n",
		"mx",
		function()
			require("agentic").stop_generation()
		end,
		"Stop Agentic generation",
	},
}

for _, km in ipairs(agentic_maps) do
	local modes = km[1]
	local lhs = "<leader>" .. km[2]
	local rhs = km[3]
	local opts = km[4]
	if type(opts) == "string" then
		opts = { desc = opts }
	else
		opts.desc = opts.desc or "Agentic"
	end
	map(modes, lhs, rhs, opts)
end

-- =============================================================================
-- Copilot
-- =============================================================================
vim.keymap.set("i", "<S-Tab>", 'copilot#Accept("\\<S-Tab>")', {
	expr = true,
	replace_keycodes = false,
	desc = "Copilot accept suggestion",
})
vim.keymap.set("i", "<C-l>", 'copilot#Accept("\\<CR>")', {
	expr = true,
	replace_keycodes = false,
	desc = "Copilot accept suggestion (alt)",
})

-- =============================================================================
-- Tree-sitter Text Objects (Neovim 0.12+)
-- =============================================================================
-- <A-o>  expand selection to parent node (with LSP fallback)
-- <A-i>  shrink selection to child node  (with LSP fallback)
-- On macOS, Alt+o sends "ø" and Alt+i sends "ı" — map both to be safe.
local function ts_parent()
	local parser = vim.treesitter.get_parser(nil, nil, { error = false })
	if parser then
		require("vim.treesitter._select").select_parent(vim.v.count1)
	else
		vim.lsp.buf.selection_range(vim.v.count1)
	end
end
local function ts_child()
	if vim.treesitter.get_parser(nil, nil, { error = false }) then
		require("vim.treesitter._select").select_child(vim.v.count1)
	else
		vim.lsp.buf.selection_range(-vim.v.count1)
	end
end

vim.keymap.set({ "n", "x", "o" }, "<A-o>", ts_parent, { desc = "Select parent treesitter node" })
vim.keymap.set({ "n", "x", "o" }, "ø",     ts_parent, { desc = "Select parent treesitter node (macOS Alt+o)" })
vim.keymap.set({ "n", "x", "o" }, "<A-i>", ts_child, { desc = "Select child treesitter node" })
vim.keymap.set({ "n", "x", "o" }, "ı",     ts_child, { desc = "Select child treesitter node (macOS Alt+i)" })
vim.keymap.set({ "n", "x", "o" }, "ˆ",     ts_child, { desc = "Select child treesitter node (macOS Alt+i fallback)" })
