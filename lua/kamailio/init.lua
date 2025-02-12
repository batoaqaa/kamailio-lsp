vim.filetype.add {
  extension = {
    -- change *.cfg files to kamailio file type only for any of the below condition
    cfg = function(path, bufnr)
      --Special Regex Characters: ., +, *, ?, ^, $, (, ), [, ], {, }, |, \
      if vim.fn.search [[^\s*#!\(KAMAILIO\|OPENSER\|SER\|ALL\|MAXCOMPAT\)]] > 0 then
        vim.api.nvim_win_set_cursor(0, { 1, 0 })
        return 'kamailio'
      elseif vim.fn.search [[^\s*\(request_r\|r\|branch_r\|failure_r\|reply_r\|onreply_r\|onsend_r\|event_r\)oute.*\_s*{\s*]] > 0 then
        vim.api.nvim_win_set_cursor(0, { 1, 0 })
        return 'kamailio'
      elseif vim.fn.search [[^\s*\(#\|!\)!\(define\|ifdef\|ifndef\|endif\|subst\|substdef\)]] > 0 then
        vim.api.nvim_win_set_cursor(0, { 1, 0 })
        return 'kamailio'
      elseif vim.fn.search [[^\s*modparam\s*(\s*"[^"]\+"]] > 0 then
        vim.api.nvim_win_set_cursor(0, { 1, 0 })
        return 'kamailio'
      elseif vim.fn.search [[^\s*loadmodule\s]] > 0 then
        vim.api.nvim_win_set_cursor(0, { 1, 0 })
        return 'kamailio'
      elseif vim.fn.search [[^\s*include_file]] > 0 then
        vim.api.nvim_win_set_cursor(0, { 1, 0 })
        return 'kamailio'
      end
    end,
  },
  filename = {
    ['kamctlrc'] = 'kamailio', -- if file name is 'kamctlrc' chane file type to kamailio
  },
  pattern = {
    ['.*'] = {
      --set files that start with '#!KAMAILIO ,#!OPENSER, #!SER ,#!ALL or #!MAXCOMPAT' as kamailio file type
      function(_, bufnr)
        local content = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] or ''
        if vim.regex([[^\s*#!\(KAMAILIO\|OPENSER\|SER\|ALL\|MAXCOMPAT\)]]):match_str(content) ~= nil then
          return 'kamailio'
        end
      end,
    },
  },
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
      -- optional entries:
      branch = 'main', -- default branch in case of git repo if different from master
      -- branch = 'v0.1.2',
      -- revision = 'v0.1.2',
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
