local config = require 'kamailio.config'
local M = {}

M.setup = function(opts)
  -- opts = opts or {}
  opts = vim.tbl_deep_extend('force', opts or {}, config.server_opts)

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

  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'kamailio',
    --callback = function(args)
    callback = function()
      local id = vim.lsp.start(config.server_opts)
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
