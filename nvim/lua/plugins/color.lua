return {
	{
		"rose-pine/neovim",
		config = function()
			vim.cmd([[
                colorscheme rose-pine
                highlight Normal guibg=NONE ctermbg=NONE
                highlight NonText guibg=NONE ctermbg=NONE
                highlight NormalNC guibg=NONE ctermbg=NONE
                highlight LineNr guibg=NONE ctermbg=NONE
                highlight CursorLineNr guibg=NONE ctermbg=NONE
            ]])
		end,
	},
}
