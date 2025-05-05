return {
    {
  "kyazdani42/nvim-tree.lua",
  config = function()
    require("nvim-tree").setup {
      disable_netrw = true,
      hijack_netrw = true,
      open_on_tab = false,
      auto_close = true,
      update_cwd = true,
      view = {
        side = "left",
        width = 30,
        mappings = {
          custom_only = false,
          list = {
            { key = {"<CR>", "o", "<2-LeftMouse>"}, action = "edit" },
            { key = "<Leader>e", action = "edit" },
          },
        },
      },
      git = {
        enable = true,
        ignore = false,
      },
    }

    -- Keybinding for <Leader>ff
    vim.api.nvim_set_keymap('n', '<Leader>ff', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
  end
}
}
