return {
    {
          "xsoder/buffer-manager.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
            "nvim-telescope/telescope.nvim",
        },
        config = function()
            require("buffer-manager").setup({
                auto_load_session = false,
                window = {
                    width = 0.6,
                    height = 0.5,
                },
            })
        end,
    },
}
