return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		opts = {
			auto_install = true,
		},
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local lspconfig = require("lspconfig")

			-- Ensure Mason installs the VSCode Language Server
			require("mason-lspconfig").setup({
				ensure_installed = {
					"ts_ls", -- TypeScript
					"html", -- HTML
					"lua_ls", -- Lua
					"rust_analyzer", -- Rust
					"pyright", -- Python
					"clangd", -- C/C++
					"cssls", -- CSS
					"jsonls", -- JSON
					"eslint", -- ESLint
				},
			})

			-- Setup LSP Servers
			local servers = {
				ts_ls = {},
				solargraph = {},
				html = {},
				lua_ls = {},
				rust_analyzer = {},
				pyright = {},
				clangd = {},
				cssls = {},
				jsonls = {},
				eslint = {},
			}

			for server, config in pairs(servers) do
				lspconfig[server].setup(vim.tbl_extend("force", { capabilities = capabilities }, config))
			end

			-- Keybindings
			local opts = { noremap = true, silent = true }
			vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
			vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
			vim.keymap.set("n", "fq", vim.lsp.buf.code_action, opts)
			vim.keymap.set("n", "do", ":copen<CR>", opts) -- Open diagnostics
			vim.keymap.set("n", "dc", ":cclose<CR>", opts) -- Close diagnostics
		end,
	},
}
