-- =============================================================================
-- KEYMAPS
-- =============================================================================
-- Keymap Prefix Reference:
--   <leader>b  = Buffers
--   <leader>f  = Find (fzf-lua search)
--   <leader>g  = Git (gitsigns + fzf git)
--   <leader>l  = LSP actions
--   <leader>o  = OpenCode AI
--   <leader>p  = Plugins (Mason, Pack, Kanban, Typst)
--   <leader>t  = Terminal / Tools
--   <leader>w  = Window management

local fzf = require("fzf-lua")
-- local opencode = require("opencode")
local Terminal = require("toggleterm.terminal").Terminal

-- =============================================================================
-- Terminal Instances
-- =============================================================================
local lazygit = Terminal:new({ cmd = "lazygit", direction = "float", hidden = true })
local thoth = Terminal:new({ cmd = "thoth", direction = "float", hidden = true })

-- =============================================================================
-- Helper Functions
-- =============================================================================

-- Terminal toggles
local function toggle_lazygit()
	lazygit:toggle()
end

local function toggle_thoth()
	thoth:toggle()
end

-- -- OpenCode functions
-- local function toggle_opencode()
-- 	opencode.toggle()
-- end
-- 
-- local function ask_about_code()
-- 	opencode.ask("@cursor: ")
-- end
-- 
-- local function ask_about_selection()
-- 	opencode.ask("@selection: ")
-- end
-- 
-- local function add_buffer_to_prompt()
-- 	opencode.prompt("@buffer", { append = true })
-- end
-- 
-- local function add_selection_to_prompt()
-- 	opencode.prompt("@selection", { append = true })
-- end
-- 
-- local function explain_code()
-- 	opencode.prompt("Explain @cursor and its context")
-- end
-- 
-- local function new_session()
-- 	opencode.command("session_new")
-- end
-- 
-- local function scroll_up()
-- 	opencode.command("messages_half_page_up")
-- end
-- 
-- local function scroll_down()
-- 	opencode.command("messages_half_page_down")
-- end
-- 
-- local function select_prompt()
-- 	opencode.select()
-- end

-- =============================================================================
-- General: Saving & Quitting
-- =============================================================================
vim.keymap.set({ "n", "i" }, "<leader>s", "<Esc><cmd>w<CR>", { desc = "Save", nowait = true })
vim.keymap.set("n", "<leader>q", ":wqall<CR>", { desc = "Quit all" })
vim.keymap.set("n", "<leader>S", "<cmd>source %<CR>", { desc = "Source current file" })
vim.keymap.set("n", "<leader>Q", ":qall!<CR>", { desc = "Force quit all" })
vim.keymap.set("n", "<leader>r", "<cmd>checktime<CR>", { desc = "Refresh file" })

-- =============================================================================
-- General: Search
-- =============================================================================
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- =============================================================================
-- General: Line Navigation
-- =============================================================================
vim.keymap.set({ "n", "v", "i" }, "<Home>", "<Home>", { noremap = true })
vim.keymap.set({ "n", "v", "i" }, "<End>", "<End>", { noremap = true })
vim.keymap.set("n", "<leader>a", "^", { desc = "Go to line start" })
vim.keymap.set("n", "<leader>e", "$", { desc = "Go to line end" })
vim.keymap.set("i", "<C-a>", "<C-o>^", { desc = "Go to line start" })
vim.keymap.set("i", "<C-e>", "<End>", { desc = "Go to line end" })


-- =============================================================================
-- General: Jumplist Navigation
-- =============================================================================
vim.keymap.set("n", "<M-left>", "g;", { desc = "Older cursor position" })
vim.keymap.set("n", "<M-right>", "g,", { desc = "Newer cursor position" })

-- =============================================================================
-- General: Line Movement
-- =============================================================================
vim.keymap.set("n", "<M-down>", ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<M-up>", ":m .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("v", "<M-down>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<M-up>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- =============================================================================
-- General: Clipboard
-- =============================================================================
vim.keymap.set("n", "<leader>y", "<cmd>%y+<CR>", { desc = "Yank buffer to clipboard" })
vim.keymap.set({ "n", "v" }, "<C-a>", "<Esc>ggVG", { desc = "Select all" })

-- =============================================================================
-- Buffers: <leader>b
-- =============================================================================
vim.keymap.set("n", "<leader>bb", fzf.buffers, { desc = "List buffers" })
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })
vim.keymap.set("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<M-S-left>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<M-S-right>", "<cmd>bnext<CR>", { desc = "Next buffer" })

-- =============================================================================
-- Find: <leader>f (fzf-lua)
-- =============================================================================
vim.keymap.set("n", "<leader>ff", fzf.files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", fzf.live_grep, { desc = "Find grep" })
vim.keymap.set("n", "<leader>fw", fzf.grep_cword, { desc = "Find word under cursor" })
vim.keymap.set("n", "<leader>fh", fzf.help_tags, { desc = "Find help" })
vim.keymap.set("n", "<leader>fc", fzf.commands, { desc = "Find commands" })
vim.keymap.set("n", "<leader>fr", fzf.oldfiles, { desc = "Find recent files" })
vim.keymap.set("n", "<leader>f/", fzf.blines, { desc = "Find in buffer" })

-- =============================================================================
-- Git: <leader>g (unified gitsigns + fzf git)
-- =============================================================================
-- Git status/history (fzf)
vim.keymap.set("n", "<leader>gs", fzf.git_status, { desc = "Git status" })
vim.keymap.set("n", "<leader>gc", fzf.git_commits, { desc = "Git commits" })
vim.keymap.set("n", "<leader>gC", fzf.git_bcommits, { desc = "Git buffer commits" })
vim.keymap.set("n", "<leader>gb", fzf.git_branches, { desc = "Git branches" })
-- Git hunks (gitsigns)
vim.keymap.set("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<CR>", { desc = "Preview hunk" })
vim.keymap.set("n", "<leader>gr", "<cmd>Gitsigns reset_hunk<CR>", { desc = "Reset hunk" })
vim.keymap.set("n", "<leader>gR", "<cmd>Gitsigns reset_buffer<CR>", { desc = "Reset buffer" })
vim.keymap.set("n", "<leader>gd", "<cmd>Gitsigns diffthis<CR>", { desc = "Diff this" })
-- Git blame (gitsigns)
vim.keymap.set("n", "<leader>gl", "<cmd>Gitsigns toggle_current_line_blame<CR>", { desc = "Toggle line blame" })
vim.keymap.set("n", "<leader>gB", "<cmd>Gitsigns blame<CR>", { desc = "Blame buffer" })
-- Hunk navigation (standard [ ] motion)
vim.keymap.set("n", "]h", "<cmd>Gitsigns next_hunk<CR>", { desc = "Next hunk" })
vim.keymap.set("n", "[h", "<cmd>Gitsigns prev_hunk<CR>", { desc = "Previous hunk" })

-- =============================================================================
-- LSP: <leader>l
-- =============================================================================
-- Goto: <leader>lg
vim.keymap.set("n", "<leader>lgd", fzf.lsp_definitions, { desc = "Definition" })
vim.keymap.set("n", "<leader>lgD", fzf.lsp_declarations, { desc = "Declaration" })
vim.keymap.set("n", "<leader>lgi", fzf.lsp_implementations, { desc = "Implementation" })
vim.keymap.set("n", "<leader>lgt", fzf.lsp_typedefs, { desc = "Type definition" })
-- Find/Search
vim.keymap.set("n", "<leader>lr", fzf.lsp_references, { desc = "References" })
vim.keymap.set("n", "<leader>ls", fzf.lsp_document_symbols, { desc = "Document symbols" })
vim.keymap.set("n", "<leader>lS", fzf.lsp_workspace_symbols, { desc = "Workspace symbols" })
-- Actions
vim.keymap.set("n", "<leader>la", fzf.lsp_code_actions, { desc = "Code actions" })
vim.keymap.set("n", "<leader>ln", vim.lsp.buf.rename, { desc = "Rename symbol" })
vim.keymap.set("n", "<leader>lh", vim.lsp.buf.hover, { desc = "Hover documentation" })
vim.keymap.set("n", "<leader>lf", function()
	require("conform").format()
end, { desc = "Format buffer" })
-- Diagnostics: <leader>lx
vim.keymap.set("n", "<leader>lxd", fzf.diagnostics_document, { desc = "Document diagnostics" })
vim.keymap.set("n", "<leader>lxw", fzf.diagnostics_workspace, { desc = "Workspace diagnostics" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })

-- =============================================================================
-- Window: <leader>w
-- =============================================================================
vim.keymap.set("n", "<leader>wv", "<cmd>vsplit<CR>", { desc = "Split vertical" })
vim.keymap.set("n", "<leader>ws", "<cmd>split<CR>", { desc = "Split horizontal" })
vim.keymap.set("n", "<leader>wc", "<cmd>close<CR>", { desc = "Close window" })
vim.keymap.set("n", "<leader>wo", "<cmd>only<CR>", { desc = "Close other windows" })
vim.keymap.set("n", "<leader>w=", "<C-w>=", { desc = "Balance windows" })
-- Window navigation
vim.keymap.set("n", "<leader>wh", "<C-w>h", { desc = "Go left" })
vim.keymap.set("n", "<leader>wj", "<C-w>j", { desc = "Go down" })
vim.keymap.set("n", "<leader>wk", "<C-w>k", { desc = "Go up" })
vim.keymap.set("n", "<leader>wl", "<C-w>l", { desc = "Go right" })
vim.keymap.set("n", "<leader>w<left>", "<C-w>h", { desc = "Go left" })
vim.keymap.set("n", "<leader>w<down>", "<C-w>j", { desc = "Go down" })
vim.keymap.set("n", "<leader>w<up>", "<C-w>k", { desc = "Go up" })
vim.keymap.set("n", "<leader>w<right>", "<C-w>l", { desc = "Go right" })

-- =============================================================================
-- Terminal: <leader>t
-- =============================================================================
vim.keymap.set("n", "<leader>tt", ":ToggleTerm direction=float<CR>", { desc = "Toggle terminal" })
vim.keymap.set("n", "<leader>th", ":ToggleTerm direction=horizontal<CR>", { desc = "Terminal horizontal" })
vim.keymap.set("n", "<leader>tv", ":ToggleTerm direction=vertical<CR>", { desc = "Terminal vertical" })
vim.keymap.set("n", "<leader>tg", toggle_lazygit, { desc = "Lazygit" })
vim.keymap.set("n", "<leader>to", toggle_thoth, { desc = "Thoth" })
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- -- =============================================================================
-- -- OpenCode AI: <leader>o
-- -- =============================================================================
-- vim.keymap.set("n", "<leader>oo", toggle_opencode, { desc = "Toggle OpenCode" })
-- vim.keymap.set("n", "<leader>oa", ask_about_code, { desc = "Ask about code" })
-- vim.keymap.set("v", "<leader>oa", ask_about_selection, { desc = "Ask about selection" })
-- vim.keymap.set("n", "<leader>ob", add_buffer_to_prompt, { desc = "Add buffer to prompt" })
-- vim.keymap.set("v", "<leader>ob", add_selection_to_prompt, { desc = "Add selection to prompt" })
-- vim.keymap.set("n", "<leader>oe", explain_code, { desc = "Explain code" })
-- vim.keymap.set("n", "<leader>on", new_session, { desc = "New session" })
-- vim.keymap.set("n", "<leader>os", select_prompt, { desc = "Select prompt" })
-- vim.keymap.set("n", "<C-S-u>", scroll_up, { desc = "OpenCode scroll up" })
-- vim.keymap.set("n", "<C-S-d>", scroll_down, { desc = "OpenCode scroll down" })

-- =============================================================================
-- Plugins: <leader>p
-- =============================================================================
vim.keymap.set("n", "<leader>pm", "<cmd>Mason<CR>", { desc = "Mason" })
vim.keymap.set("n", "<leader>pu", "<cmd>lua vim.pack.update()<CR>", { desc = "Update plugins" })
vim.keymap.set("n", "<leader>pk", "<cmd>Kanban<CR>", { desc = "Kanban board" })
-- Typst Preview
vim.keymap.set("n", "<leader>ptp", "<cmd>TypstPreview<CR>", { desc = "Typst preview" })
vim.keymap.set("n", "<leader>pts", "<cmd>TypstPreviewStop<CR>", { desc = "Typst preview stop" })
vim.keymap.set("n", "<leader>ptt", "<cmd>TypstPreviewToggle<CR>", { desc = "Typst preview toggle" })

-- =============================================================================
-- File Explorer: Oil
-- =============================================================================
vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "File explorer (Oil)" })

-- =============================================================================
-- Copilot
-- =============================================================================
vim.keymap.set("i", "<S-Tab>", 'copilot#Accept("\\<S-Tab>")', { expr = true, replace_keycodes = false })
