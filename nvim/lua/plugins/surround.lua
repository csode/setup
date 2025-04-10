-- In your `plugins.lua` or appropriate setup file
return {
	{
		"tpope/vim-surround",
		config = function()
			vim.api.nvim_set_keymap("n", "<leader>s*", "ysiw*", { noremap = true, silent = true })
			vim.api.nvim_set_keymap("n", '<leader>s"', 'ysiw"', { noremap = true, silent = true })
			vim.api.nvim_set_keymap("n", "<leader>s#", "ysiw#", { noremap = true, silent = true })
			vim.api.nvim_set_keymap("n", "<leader>sf", "ysiw/*", { noremap = true, silent = true })
		end,
	},
}
