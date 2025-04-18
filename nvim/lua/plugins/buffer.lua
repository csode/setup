return {
	"xsoder/buffer-manager",
	dependencies = {
		"ibhagwan/fzf-lua",
		"nvim-tree/nvim-web-devicons",
		"nvim-lua/plenary.nvim",
	},
	config = function()
		require("buffer-manager").setup()
	end,
}
