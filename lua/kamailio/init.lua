vim.filetype.add {
  extension = {
    cfg = 'kamailio',
  },
  filename = {
    ['kamctlrc'] = 'kamailio',
  },
  pattern = {
    ['.*'] = {
      --set files that start with '#!KAMAILIO' as kamailio file type
      function(_, bufnr)
        local content = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] or ''
        -- if vim.regex([[^#!.*KAMAILIO]]):match_str(content) ~= nil then
        if vim.regex([[^\s*#!\(KAMAILIO\|OPENSER\|SER\|ALL\|MAXCOMPAT\)]]):match_str(content) ~= nil then
          return 'kamailio'
        end
      end,
    },
  },

  -- let max = line("$") > 400 ? 400 : line("$")
  -- for n in range(1, max)
  --    if getline(n) =~ '^\s*#!\(KAMAILIO\|OPENSER\|SER\|ALL\|MAXCOMPAT\)'
  --       set filetype=kamailio
  --       return
  --    elseif getline(n) =~ '^\s*#!\(define\|ifdef\|ifndef\|endif\|subst\|substdef\)'
  --       set filetype=kamailio
  --       return
  --    elseif getline(n) =~ '^\s*!!\(define\|ifdef\|ifndef\|endif\|subst\|substdef\)'
  --       set filetype=kamailio
  --       return
  --    elseif getline(n) =~ '^\s*modparam\s*(\s*"[^"]\+"'
  --       set filetype=kamailio
  --       return
  --    elseif getline(n) =~ '^\s*loadmodule\s'
  --       set filetype=kamailio
  --       return
  --    elseif getline(n) =~ '^\s*request_route\s*{\s*'
  --       set filetype=kamailio
  --       return
  --    elseif getline(n) =~ '^\s*route\s*{\s*'
  --       set filetype=kamailio
  --       return
  --    endif
  -- endfor
}
---------------------------------------------------------------------------------------------------------------
local parsers = require 'nvim-treesitter.parsers'
local parser_config = parsers.get_parser_configs()
if not parser_config['kamailio'] then
  parser_config['kamailio'] = {
    install_info = {
      -- url = 'https://github.com/IbrahimShahzad/tree-sitter-kamailio-cfg',
      url = 'https://github.com/batoaqaa/tree-sitter-kamailio',
      files = { 'src/parser.c' }, -- note that some parsers also require src/scanner.c or src/scanner.cc
      branch = 'main',
      -- branch = 'v0.1.2',
      -- revision = 'v0.1.2',
      -- optional entries:
      generate_requires_npm = false, -- if stand-alone parser without npm dependencies
      requires_generate_from_grammar = false, -- if folder contains pre-generated src/parser.c
    },
    filetype = 'kamailio', -- if filetype does not match the parser name
  }
end
if parser_config['kamailio'] and not parsers.has_parser 'kamailio' then
  vim.cmd 'TSInstallSync kamailio'
  -- vim.cmd 'TSInstallFromGrammar kamailio'
end
---------------------------------------------------------------------------------------------------------------
local M = {}

M.setup = function(opts)
  local lsp_config = require('kamailio.config').server_opts
  lsp_config = vim.tbl_deep_extend('force', lsp_config or {}, opts)
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'kamailio',
    callback = function()
      local id = vim.lsp.start(lsp_config)
      if not id then
        vim.notify('Failed to start LSP client', vim.log.levels.ERROR)
        return
      end
    end,
  })
end

return M
