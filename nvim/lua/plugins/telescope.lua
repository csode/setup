return {
    "nvim-telescope/telescope.nvim",

    dependencies = {
        "nvim-lua/plenary.nvim",
        "jvgrootveld/telescope-zoxide",
    },

    config = function()
        require('telescope').setup({
            extensions = {
                zoxide = {
                    prompt_title = "[ Zoxide List ]",
                    mappings = {
                        default = {
                            after_action = function(selection)
                                if not selection or not selection.path then
                                    print("No valid selection.")
                                    return
                                end
                                vim.cmd("cd " .. selection.path)
                                print("Changed directory to: " .. selection.path)
                            end,
                        },
                    },
                },
            },
        })

        require("telescope").load_extension("zoxide")

        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
        vim.keymap.set('n', '<C-p>', builtin.git_files, {})
        vim.keymap.set('n', '<leader>pws', function()
            local word = vim.fn.expand("<cword>")
            builtin.grep_string({ search = word })
        end)
        vim.keymap.set('n', '<leader>pWs', function()
            local word = vim.fn.expand("<cWORD>")
            builtin.grep_string({ search = word })
        end)
        vim.keymap.set('n', '<leader>ps', function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end)
        vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})

        -- Zoxide picker keymap
        vim.keymap.set('n', '<leader>z', function()
            require("telescope").extensions.zoxide.list()
        end, { desc = "Zoxide Jump" })
    end
}

