return {
    {
        "stevearc/oil.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            -- Custom function to display the current path in the winbar
            CustomOilBar = function()
                local path = vim.fn.expand("%")
                path = path:gsub("oil://", "")
                return "  " .. vim.fn.fnamemodify(path, ":.")
            end

            -- Function to get file permissions for a given path
            local function get_permissions(entry)
                local filepath = entry.path
                local perms = vim.fn.system("ls -l " .. filepath)
                return perms:match("^[^ ]+") -- Extract permissions (first part of 'ls -l' output)
            end

            -- Setup oil.nvim
            require("oil").setup({
                skip_confirm_for_simple_edits = true,
                prompt_save_on_select_new_entry = false,
                confirm = false,
                columns = {
                    {
                        label = "Permissions",            -- Label for permissions column
                        get_value = function(entry)
                            return get_permissions(entry) -- Fetch and display permissions
                        end,
                    },
                },
                keymaps = {
                    ["<C-h>"] = false,
                    ["<C-l>"] = false,
                    ["<C-k>"] = false,
                    ["<C-j>"] = false,
                    ["<M-h>"] = "actions.select_split",
                    ["<C-s>"] = false,
                },
                view_options = {
                    show_hidden = true,
                    is_always_hidden = function(name, _)
                        local folder_skip = { "dev-tools.locks", "dune.lock", "_build" }
                        return vim.tbl_contains(folder_skip, name)
                    end,
                },
            })

            vim.keymap.set("n", "<space>'", function()
                -- Check if the current buffer is an 'oil' buffer by looking at the filetype
                if vim.bo.filetype == "oil" then
                    -- If it's an 'oil' buffer, delete the buffer (close the oil window)
                    vim.cmd("bdelete") -- Delete the 'oil' buffer without closing the window
                else
                    -- Otherwise, open Oil
                    require("oil").open() -- Open Oil
                end
            end, { desc = "Toggle parent directory" })
        end,
    },
}

