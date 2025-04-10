function ColorMyPencils(color)
    color = color or "rose-pine-moon"

    -- Check if the colorscheme exists before applying it
    local ok, _ = pcall(vim.cmd, "colorscheme " .. color)
    if not ok then
        vim.notify("Colorscheme '" .. color .. "' not found! Using default.", vim.log.levels.WARN)
        vim.cmd("colorscheme default") -- Fallback to default if not found
    end

    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

return {
    {
        "erikbackman/brightburn.vim",
    },

    {
        "folke/tokyonight.nvim",
        lazy = false,
        opts = {},
        config = function()
            require("tokyonight").setup({
                style = "storm",    -- Options: "storm", "moon", "night", "day"
                transparent = true, -- Enable transparency
                terminal_colors = true,
                styles = {
                    comments = { italic = false },
                    keywords = { italic = false },
                    sidebars = "dark",
                    floats = "dark",
                },
            })
        end
    },

    {
        "ellisonleao/gruvbox.nvim",
        name = "gruvbox",
        config = function()
            require("gruvbox").setup({
                terminal_colors = true,
                undercurl = true,
                underline = false,
                bold = true,
                italic = { comments = false },
                inverse = true, -- Invert background for search, diffs, etc.
                transparent_mode = false,
            })
        end,
    },

    {
        "rose-pine/neovim",
        name = "rose-pine",
        config = function()
            require("rose-pine").setup({
                disable_background = true,
                styles = {
                    italic = false,
                },
            })
            ColorMyPencils()
        end
    }
}
