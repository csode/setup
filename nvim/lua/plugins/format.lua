return {
    'lukas-reineke/lsp-format.nvim',

    config = function()
        -- Load the plugin
        require('lsp-format').setup {}

        vim.api.nvim_create_autocmd('BufWritePre', {
            group = vim.api.nvim_create_augroup('LspAutoFormat', { clear = true }),
            pattern = '*', -- This applies to all filetypes
            callback = function()
                if vim.lsp.buf_get_clients() ~= {} then
                    vim.lsp.buf.format({ async = true })
                else
                    print("No active LSP client, skipping format!")
                end
            end,
        })
    end
}
