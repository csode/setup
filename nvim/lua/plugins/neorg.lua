return {
    "nvim-orgmode/orgmode",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
        require("orgmode").setup({
            org_agenda_files = { "~/notes/*" },
            org_default_notes_file = "~/org/refile.org",
        })
    end,
}
