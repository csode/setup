return {
	{
		"rose-pine/neovim",
		config = function()
			vim.cmd([[
				colorscheme rose-pine

				" Main backgrounds
				highlight Normal guibg=NONE ctermbg=NONE
				highlight NormalNC guibg=NONE ctermbg=NONE
				highlight NonText guibg=NONE ctermbg=NONE

				" Line numbers
				highlight LineNr guibg=NONE ctermbg=NONE
				highlight CursorLineNr guibg=NONE ctermbg=NONE

				" Folds
				highlight Folded guibg=NONE ctermbg=NONE
				highlight FoldColumn guibg=NONE ctermbg=NONE

				" Sign column (like git signs, diagnostics)
				highlight SignColumn guibg=NONE ctermbg=NONE
				" Vert splits
				highlight VertSplit guibg=NONE ctermbg=NONE

				" Tab line
				highlight TabLine guibg=NONE ctermbg=NONE
				highlight TabLineFill guibg=NONE ctermbg=NONE
				highlight TabLineSel guibg=NONE ctermbg=NONE

				" Popup menus
				highlight Pmenu guibg=NONE ctermbg=NONE
				highlight PmenuSel guibg=NONE ctermbg=NONE

				" Floating windows
				highlight NormalFloat guibg=NONE ctermbg=NONE
				highlight FloatBorder guibg=NONE ctermbg=NONE

				" LSP-related floating things
				highlight LspFloatWinNormal guibg=NONE ctermbg=NONE
				highlight LspFloatWinBorder guibg=NONE ctermbg=NONE

				" Telescope (if you use it)
				highlight TelescopeNormal guibg=NONE ctermbg=NONE
				highlight TelescopeBorder guibg=NONE ctermbg=NONE

				" WhichKey (if you use it)
				highlight WhichKeyFloat guibg=NONE ctermbg=NONE
			]])
		end,
	},
}
