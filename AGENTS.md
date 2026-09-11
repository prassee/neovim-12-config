# Neovim Configuration - Agent Instructions

## Project Overview

This is a Neovim 0.12+ configuration using `vim.pack` (built-in package management).

## Project Structure

- `init.lua` - Main entry point with options and plugin declarations
- `lua/plugins.lua` - Plugin configurations
- `lua/keymaps.lua` - Keymaps and shortcuts
- `lua/autocmds.lua` - Autocommands

## Key Plugins

| Plugin | Purpose |
|--------|---------|
| nvim-treesitter | Syntax highlighting and indentation |
| nvim-lspconfig | LSP client configuration |
| mason.nvim / mason-lspconfig.nvim | LSP server installation |
| blink.cmp | Completion engine |
| LuaSnip / friendly-snippets | Snippets |
| fzf-lua | Fuzzy finder |
| conform.nvim | Formatting |
| agentic.nvim | AI assistance |
| copilot.vim | Inline AI completion |
| pyrepl.nvim | Python REPL |
| match.nvim | Search and replace |
| mini.clue/surround | Surround text and key hints |
| Comment.nvim | Line/block commenting |
| oil.nvim | File explorer |
| neogit | Git interface |
| gitsigns.nvim | Git signs |
| gitlab.nvim | GitLab MRs/reviews from Neovim |
| diffview-plus.nvim | Diff viewer (maintained diffview.nvim fork) |
| toggleterm.nvim | Terminal management |
| render-markdown.nvim | Markdown rendering |
| tokyonight.nvim | Colorscheme |
| lualine.nvim | Statusline |

## LSP Servers

Auto-enabled: `lua_ls`, `gopls`, `pyrefly`, `dockerls`, `taplo`, `jsonls`, `marksman`, `yamlls`

## Keymaps Reference

| Prefix | Category |
|--------|----------|
| `<leader>b` | Buffers |
| `<leader>f` | Find (fzf-lua) |
| `<leader>g` | Git (gitsigns + fzf git) |
| `<leader>j` | PyREPL |
| `<leader>l` | LSP actions |
| `<leader>n` | Neogit |
| `<leader>p` | Plugins (Mason, Pack) |
| `<leader>t` | Terminal |
| `<leader>w` | Window management |
| `<leader>x` | Agentic |
| `<leader>rs` | Search & Replace (match.nvim) |

### Treesitter Selection

- `<A-o>` (or `ø` on macOS) — expand selection to parent treesitter node, falling back to LSP `selection_range` when no parser is available
- `<A-i>` (or `ı`/`ˆ` on macOS) — shrink selection to child treesitter node, with the same LSP fallback

## Important Patterns

### Adding new plugins
Plugins are added to `init.lua` using `vim.pack.add()`:
```lua
vim.pack.add({ "https://github.com/author/plugin" })
```

### Adding new keymaps
Keymaps go in `lua/keymaps.lua` using the `map()` helper:
```lua
map("n", "<leader>xy", "<cmd>SomeCommand<CR>", { desc = "Description" })
```

### Adding plugin configuration
Add to `lua/plugins.lua`:
```lua
require("plugin-name").setup({ ... })
```

## Formatting

Formatter configuration is in `lua/plugins.lua` under conform.nvim:
- lua → stylua
- go → gofmt
- python → black
- rust → rustfmt
- json → jq
- html/django → djlint
- javascript → prettier
- yaml → prettier
- yaml.docker-compose → yamlfmt
- sh/bash/zsh → shfmt

## AI Assistance

- Agentic.nvim uses `claude-agent-acp` provider
- Copilot is enabled for: lua, go, python, rust
- Keymaps: `<leader>xa` (toggle), `<leader>xf` (add file), `<leader>xc` (add context)

## Code Style Guidelines

- Use tabs (2 spaces)
- Follow existing conventions in each file
- Add descriptions to all keymaps
- Use Lua patterns matching the codebase style