return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-live-grep-args.nvim",
    },
    config = function()
        -- Load Telescope and the live grep args extension
        require("telescope").setup({
            defaults = {
                winblend = 0,
                winhighlight = "Normal:Normal,FloatBorder:Normal,Search:Search",
                file_ignore_patterns = {
                    "vendor",
                    "vendor/",
                    "node_modules",
                    "/venv",
                    "node_modules/",
                    "/target",
                    "/assets",
                    "/asset",
                    "/build",
                    "/.git",
                    "*.lock",
                    "*.swp",
                    "media/",
                    "/media",
                }, -- Ignore specific file types or patterns
                hidden = true, -- Ensure hidden files are shown (excluding those ignored)
            },
            extensions = {
                live_grep_args = { -- Configuration for live grep args
                    auto_quoting = true, -- Enable/disable auto quoting
                },
            },
        })

        -- Load Telescope extensions
        require("telescope").load_extension("live_grep_args")

        -- Define the Find and Replace function
        local M = {}

        -- Function to find and replace within the current buffer using Telescope UI
        M.find_and_replace = function()
            -- Step 1: Open Telescope prompt to search for the word (without previewing results)
            require("telescope.builtin").grep_string({
                prompt_title = "Find",
                search = "", -- Empty search initially to prompt the user
                prefer_local = true, -- Make sure it operates on the current buffer
                previewer = false, -- Disable previewer completely
                attach_mappings = function(_, map)
                    -- Map the 'enter' key to initiate the replacement process
                    map("i", "<CR>", function(prompt_bufnr)
                        local search_term = require("telescope.actions.state").get_selected_entry().value
                        if not search_term or search_term == "" then
                            print("No search term provided.")
                            return
                        end

                        -- Step 2: Open a prompt to input the replacement term
                        vim.ui.input({ prompt = "Enter replacement word: " }, function(replacement_term)
                            if not replacement_term or replacement_term == "" then
                                print("No replacement term provided.")
                                return
                            end

                            -- Step 3: Perform replacement in the current buffer
                            local current_buf = vim.api.nvim_get_current_buf()
                            local lines = vim.api.nvim_buf_get_lines(current_buf, 0, -1, false)

                            for i, line in ipairs(lines) do
                                -- Replace all occurrences of the search term with the replacement term
                                lines[i] = line:gsub("%f[%a]" .. search_term .. "%f[%A]", replacement_term)
                            end

                            -- Step 4: Set the lines in the buffer
                            vim.api.nvim_buf_set_lines(current_buf, 0, -1, false, lines)
                            print(
                                "Replaced all occurrences of '"
                                .. search_term
                                .. "' with '"
                                .. replacement_term
                                .. "' in the current buffer."
                            )
                        end)
                    end)
                    return true
                end,
            })
        end

        -- Keybinding for the Find and Replace function
        vim.keymap.set("n", "<Leader>fr", function()
            M.find_and_replace()
        end, { noremap = true, silent = true, desc = "Find and Replace with Telescope" })

        -- Telescope file finder mappings
        local builtin = require("telescope.builtin")
        vim.keymap.set("n", "<leader>ff", function()
            builtin.find_files({
                find_command = {
                    "find",
                    ".",
                    "-type",
                    "f",
                    "-not",
                    "-path",
                    "./.git/*",
                    "-not",
                    "-path",
                    "./build/*",
                    "-not",
                    "-path",
                    "./cargo/*",
                },
            })
        end)

        -- Other Telescope mappings
        vim.keymap.set("n", "<C-p>", builtin.git_files)
        vim.keymap.set("n", "<leader>pq", function()
            local word = vim.fn.expand("<cword>")
            builtin.grep_string({ search = word })
        end)
        vim.keymap.set("n", "<leader>pWs", function()
            local word = vim.fn.expand("<cWORD>")
            builtin.grep_string({ search = word })
        end)
        vim.keymap.set("n", "<leader>ps", function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end)
        vim.keymap.set("n", "<leader>vh", builtin.help_tags, {})

        -- Live Grep with arguments
        vim.keymap.set("n", "<leader>lg", function()
            require("telescope").extensions.live_grep_args.live_grep_args()
        end, { noremap = true, silent = true, desc = "Live Grep with Arguments" })
    end,
}
