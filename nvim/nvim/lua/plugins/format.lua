return {
  'lukas-reineke/lsp-format.nvim',

  config = function()
    -- Load the plugin
    require('lsp-format').setup {}

    -- Enable auto-formatting on save
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = vim.api.nvim_create_augroup('LspAutoFormat', { clear = true }),
      pattern = '*', -- This applies to all filetypes
      callback = function()
        -- Ensure LSP is attached before formatting
        if vim.lsp.buf_get_clients() ~= {} then
          vim.lsp.buf.format({ async = true })
        else
          print("No active LSP client, skipping format!")
        end
      end,
    })
  end
}

