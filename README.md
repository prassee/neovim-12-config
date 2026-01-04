### Neovim 0.12 config 

- using the latest nightly Neovim build 
- uses built-in plugin manager (`vim.pack`)
- very minimal set of plugins with smart trade-offs
- LSP support for all major languages
- optimized for Linux & Mac
- refer to the TODO.md file for more details

## Folder Structure

```
.
├── init.lua              # Main config: options, plugins, autocommands
├── lua/
│   ├── keymaps.lua       # All keybindings (<leader> prefixes)
│   └── plugins.lua       # Plugin configurations
├── nvim-pack-lock.json   # Plugin lock file
├── README.md
└── TODO.md               # Kanban board tasks
```

## Plugins

**Core:** nvim-treesitter, nvim-lspconfig, blink.cmp, LuaSnip, friendly-snippets, mini.clue, mini.surround

**LSP & Mason:** mason.nvim, mason-lspconfig.nvim, mason-tool-installer.nvim, SchemaStore.nvim

**UI:** catppuccin (colorscheme), lualine.nvim

**File & Search:** oil.nvim, fzf-lua

**AI:** opencode.nvim (AI coding assistant), copilot.vim

**Tools:** conform.nvim, toggleterm.nvim, kanban.nvim, Comment.nvim, gitsigns.nvim, typst-preview.nvim

## LSP Support

Lua, Go, Python (pyrefly), Docker, TOML, JSON, Markdown, YAML, Typst

## Keymap Prefixes

| Prefix | Category |
|--------|----------|
| `<leader>b` | Buffers |
| `<leader>f` | Find (fzf-lua) |
| `<leader>g` | Git |
| `<leader>l` | LSP actions |
| `<leader>o` | OpenCode AI |
| `<leader>p` | Plugins |
| `<leader>t` | Terminal |
| `<leader>w` | Window management |

## Tags

| Tag | Description |
|-----|-------------|
| `v0.4.0` | Modular config - separated plugins & keymaps to own lua files |
| `v0.3.0` | Updated config |
| `v0.2.0` | Add gitsigns.nvim for git blame and hunk management |
| `v0.1.0` | Add Copilot integration and refine keymaps and config |

## Roadmap

**Done:**
- Configure OpenCode AI assistant
- Create modular structure (lua/ directory)
- Re-structure keymaps to follow consistent prefix pattern
- SQLua plugin config

**In Progress:** None

**Backlog:** None

See [TODO.md](TODO.md) for the full Kanban board.
