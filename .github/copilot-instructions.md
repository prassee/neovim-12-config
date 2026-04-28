# Neovim Configuration - Copilot Instructions

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
| blink.cmp | Completion engine |
| fzf-lua | Fuzzy finder |
| conform.nvim | Formatting |
| agentic.nvim | AI assistance |
| pyrepl.nvim | Python REPL |
| match.nvim | Search and replace |
| mini.clue/surround | Surround text and key hints |
| oil.nvim | File explorer |
| neogit | Git interface |
| gitsigns.nvim | Git signs |
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
- yaml → prettier
- sh/bash/zsh → shfmt

## AI Assistance

- Agentic.nvim uses `opencode-acp` provider
- Copilot is enabled for: lua, go, python, rust
- Keymaps: `<leader>xa` (toggle), `<leader>xf` (add file), `<leader>xc` (add context)