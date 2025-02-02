-- local opts = require("custom.plugins.lsp-config.opts")

local has_cmp_lsp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.foldingRange = { dynamicRegistration = false, lineFoldingOnly = true }
if has_cmp_lsp then
	capabilities = cmp_lsp.default_capabilities(capabilities)
end
-- M.capabilities = capabilities
-- local doautocmd = vim.api.nvim_exec_autocmds

local filetypes = {
	-- ['cfg'] = true,
	-- ['inc'] = true,
}

local server = {
	name = "KamaiZen",
	cmd = { "/home/batoaqaa/KamaiZen/KamaiZen" },
	cmd_cwd = vim.fn.getcwd(),
	filetypes = { "cfg", "inc", "kamailio" },
	root_dir = vim.fn.getcwd(),
	capabilities = capabilities,
	autostart = true,
	settings = {
		kamaizen = {
			enableDeprecatedCommentHint = false, -- to enable hints for '#' comments
			KamailioSourcePath = vim.fn.getcwd(),
			loglevel = 3,
		},
	},
	-- on_attach = function(client, bufnr)
	--   -- default completion suggestions
	--   -- triggered by using `<C-x><C-o>`
	--   vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'
	--
	--   -- Use lsp server instead of tags (whenever possible)
	--   vim.bo.tagfunc='v:lua.vim.lsp.tagfunc'
	--
	--   -- declare your keybindings elsewhere
	--   doautocmd('User', {pattern = 'LSPKeybindings'})
	-- end,
	on_init = function(client, results)
		if results.offsetEncoding then
			client.offset_encoding = results.offsetEncoding
		end

		if client.config.settings then
			client.notify("workspace/didChangeConfiguration", {
				settings = client.config.settings,
			})
		end
	end,
}

return {
	filetypes = filetypes,
	params = server,
}
