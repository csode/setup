return {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")

        -- ASCII Header
        dashboard.section.header.val = {
            "███████╗███████╗ ██████╗ ██████╗ ███████╗",
            "╚══██╔══╝██╔════╝██╔══██╗██╔══██╗██╔════╝",
            "   ██║   █████╗  ██████╔╝██████╔╝█████╗  ",
            "   ██║   ██╔══╝  ██╔═══╝ ██╔═══╝ ██╔══╝  ",
            "   ██║   ███████╗██║     ██║     ███████╗",
            "   ╚═╝   ╚══════╝╚═╝     ╚═╝     ╚══════╝",
            "",
            "                                        ",
        }

        -- Buttons
        dashboard.section.buttons.val = {
            dashboard.button("e", "New File", ":ene <BAR> startinsert <CR>"),
            dashboard.button("r", "Restore Session", ":lua require('buffer-manager.session').load_session()<CR>"),
            dashboard.button("f", "Find File", ":Telescope find_files<CR>"),
            dashboard.button("q", "Quit NVIM", ":qa<CR>"),
        }

        -- Footer (optional)
        dashboard.section.footer.val = { " Welcome back xsoder!" }

        -- Final Setup
        alpha.setup(dashboard.opts)

        -- Optional Keybind
        vim.keymap.set("n", "<leader>sl", function()
            require("buffer-manager.session").load_session()
        end, { desc = "BufferManager: Restore session" })
    end,
}
