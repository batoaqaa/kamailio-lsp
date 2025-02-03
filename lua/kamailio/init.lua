local config = require 'kamailio.config'
local M = {}

M.setup = function(opts)
  -- opts = opts or {}
  opts = vim.tbl_deep_extend('force', config.server_opts or {}, opts)

  vim.filetype.add {
    extension = {
      cfg = 'kamailio',
    },
    filename = {
      ['kamctlrc'] = 'kamailio',
    },
    pattern = {
      ['.*'] = {
        --function(path, bufnr)
        function(_, bufnr)
          local content = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] or ''
          if vim.regex([[^#!.*KAMAILIO]]):match_str(content) ~= nil then
            return 'kamailio'
          end
        end,
      },
    },
  }
  ----------------------------------------
  -- [[https://ibrahimshahzad.github.io/posts/parsing_kamailio_cfg/]]
  -- local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
  -- parser_config.kamailio = {
  --   install_info = {
  --     url = 'https://github.com/batoaqaa/tree-sitter-kamailio', --'/home/batoaqaa/tree-sitter-kamailio', --
  --     files = { 'src/parser.c' }, -- note that some parsers also require src/scanner.c or src/scanner.cc
  --     -- optional entries:
  --     branch = 'main', -- default branch in case of git repo if different from master
  --     generate_requires_npm = false, -- if stand-alone parser without npm dependencies
  --     requires_generate_from_grammar = false, -- if folder contains pre-generated src/parser.c
  --   },
  --   filetype = 'kamailio', -- if filetype does not match the parser name
  -- }
  ----------------------------------------

  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'kamailio',
    --callback = function(args)
    callback = function()
      local id = vim.lsp.start(opts) --config.server_opts)
      if not id then
        return
      end
      -- end
    end,
  })
end

-- M.config = function(opts)
--   local server_opts = require 'kamailio.config'
--
--   server_opts = vim.tbl_deep_extend('force', server_opts or {}, opts)
--
--   return server_opts
-- end

return M
