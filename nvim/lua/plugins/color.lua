return {
    {
        "vague2k/vague.nvim",
        config = function()
            require("vague").setup({
                transparent = true, -- Enable transparency
            })

            -- Set colorscheme and apply transparent highlights
            vim.cmd([[
                colorscheme vague
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

