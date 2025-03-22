return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 20000,
        config = function()
            require("catppuccin").setup({ transparent_background = true })
            vim.cmd("colorscheme " .. theme)
            vim.cmd([[
                    highlight Normal guibg=NONE ctermbg=NONE
                    highlight NonText guibg=NONE ctermbg=NONE
                    highlight NormalNC guibg=NONE ctermbg=NONE
                    highlight LineNr guibg=NONE ctermbg=NONE
                    highlight CursorLineNr guibg=NONE ctermbg=NONE
                    highlight CursorLine guibg=NONE ctermbg=NONE
                    ]])
        end,
    },
}
