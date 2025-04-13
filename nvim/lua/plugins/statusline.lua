return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "echasnovski/mini.icons" },
    config = function()
        -- Force transparency for the StatusLine and StatusLineNC
        vim.api.nvim_set_hl(0, "StatusLine", { bg = "none" })
        vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "none" })

        require("lualine").setup({
            options = {
                icons_enabled = false,
                theme = "auto",  -- You can use your desired theme here
                component_separators = "",
                section_separators = "",
            },

            sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch" },
                lualine_c = { "filename" },
                lualine_x = {
                    function()
                        encoding = vim.o.fileencoding
                        if encoding == "" then
                            return vim.bo.fileformat .. " :: " .. vim.bo.filetype
                        else
                            return encoding .. " :: " .. vim.bo.fileformat .. " :: " .. vim.bo.filetype
                        end
                    end,
                },
                lualine_y = { "progress" },
                lualine_z = { "location" },
            },
        })
    end,
}

