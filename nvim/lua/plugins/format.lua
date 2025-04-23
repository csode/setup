return {
	"lukas-reineke/lsp-format.nvim",

	config = function()
		-- Load the plugin
		require("lsp-format").setup({})

		vim.api.nvim_create_autocmd("BufWritePre", {
			group = vim.api.nvim_create_augroup("LspAutoFormat", { clear = true }),
			pattern = "*", -- Applies to all filetypes
			callback = function()
				local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
				if next(clients) ~= nil then
					vim.lsp.buf.format({ async = true })
				else
					print("No active LSP client, skipping format!")
				end
			end,
		})
	end,
}
