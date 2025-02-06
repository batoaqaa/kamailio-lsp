# kamailio-lsp

Neovim plugin to integrate the [KamaiZen Language Server](https://github.com/IbrahimShahzad/KamaiZen) and tree-sitter grammar for Kamailio configuration files.

## Installation

with [lazy.nvim](https://github.com/folke/lazy.nvim):
```lua
    {
      'batoaqaa/kamailio-lsp',
      dependencies = {
        { 'IbrahimShahzad/KamaiZen', build = 'go build' },
      },
      opts = {
        settings = {
          kamaizen = {
            enableDeprecatedCommentHint = false, -- to enable hints for '#' comments
            KamailioSourcePath = vim.fn.getcwd(),
            loglevel = 3,
          },
        },
      },
    }
```
