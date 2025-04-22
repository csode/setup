return {
    {
        dir = "~/Programming/Neogit/",
        name = "neogit",
        dev = true, -- Marks as a development plugin (if supported)
        config = function()
            require("neogit").setup({})
            -- Add keybind to open Neogit with <leader>g
            vim.keymap.set("n", "<leader>gg", function()
                require("neogit").open()
            end, { desc = "Open Neogit" })
        end,
    },
}
