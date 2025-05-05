return {
  {
    "media-tools",
    dir = "/home/csode/Programming/nvim-media",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("media_tools").setup({
        -- Default configuration
        ffmpeg_path = "ffmpeg",
        output_dir = vim.fn.expand("~/Videos/media-tools-recordings"),
        default_fps = 30,
        default_format = "mp4",
        default_quality = "medium", -- low, medium, high

        -- Default keymaps
        keymaps = {
          start_recording = "<leader>rs",
          stop_recording = "<leader>rx",
          toggle_recording = "<leader>rt",
          open_recordings = "<leader>ro",
        }
      })
    end,
  },
}
