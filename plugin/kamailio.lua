--return {}
vim.filetype.add({
	extension = {
		bbbcfg = "kamailio",
	},
	filename = {
		["kamctlrc"] = "kamailio",
	},
	pattern = {
		[".*"] = {
			--function(path, bufnr)
			function(_, bufnr)
				local content = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] or ""
				print(content)
				if vim.regex([[^#!.*KAMAILIO]]):match_str(content) ~= nil then
					return "kamailio"
				end
			end,
		},
	},
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "kamailio",
	callback = function(args)
		-- vim.lsp.buf_attach_client(args.buf, client)
		local root_dir = vim.fn.getcwd()
		if root_dir then
			require("kamailio").start("kamailio")
		end
	end,
})
