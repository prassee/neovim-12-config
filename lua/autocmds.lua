-- =============================================================================
-- AUTOCOMMANDS
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Highlight yanked text
-- -----------------------------------------------------------------------------
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- -----------------------------------------------------------------------------
-- Enable treesitter for supported filetypes
-- -----------------------------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
	pattern = {
		"lua",
		"go",
		"python",
		"rust",
		"javascript",
		"typescript",
		"json",
		"yaml",
		"toml",
		"markdown",
		"bash",
	},
	callback = function()
		vim.treesitter.start()
	end,
	desc = "Enable treesitter for supported filetypes",
})

-- -----------------------------------------------------------------------------
-- Setup commit message keymaps for Neogit
-- -----------------------------------------------------------------------------
local function opencode_ai_commit()
	local buf_name = vim.api.nvim_buf_get_name(0)
	local buf_dir = vim.fn.fnamemodify(buf_name, ":p:h")
	if buf_dir == "" then
		buf_dir = vim.fn.getcwd()
	end

	local git_root = vim.fn.system("git -C " .. buf_dir .. " rev-parse --show-toplevel 2>/dev/null")

	if git_root == "" or git_root:match("^fatal") then
		git_root = vim.fn.getcwd()
	end
	git_root = git_root:gsub("%s+", "")

	local diff_output =
		vim.fn.system("git --git-dir=" .. git_root .. "/.git --work-tree=" .. git_root .. " diff --cached 2>/dev/null")

	if diff_output == "" or diff_output:match("no changes added") then
		print("Error: No staged changes. Stage files with git add first.")
		return
	end

	local prompt = "Given this git diff, write a concise one-line commit message. OUTPUT ONLY TEXT, no quotes:\n\n"
		.. diff_output

	local cmd = string.format(
		[[echo '%s' | opencode run - -m opencode/minimax-m2.5-free --format json | jq -rn 'inputs | select(.type == "text") | .part.text']],
		prompt:gsub("'", "'\\''")
	)

	print("Generating AI commit message...")

	local msg = vim.fn.system(cmd):gsub("[\n\r]", "")

	if msg ~= "" and msg ~= "null" and #msg > 0 then
		local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
		vim.api.nvim_buf_set_lines(0, 0, #lines, false, { msg })
		vim.api.nvim_buf_set_lines(0, 1, #lines + 1, false, {})
	else
		print("Error: Could not generate message.")
	end
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "NeogitCommitMessage", "gitcommit" },
	callback = function()
		vim.keymap.set({ "n", "i" }, "S", ":wq<CR>", { buffer = true, silent = true, desc = "Save and close" })
		vim.keymap.set("n", "Q", ":bd!<CR>", { buffer = true, silent = true, desc = "Abort commit" })
		vim.keymap.set({ "n", "i" }, "G", function()
			opencode_ai_commit()
		end, { buffer = true, desc = "Generate commit message with OpenCode AI" })
	end,
	desc = "Setup commit message generation with OpenCode AI",
})