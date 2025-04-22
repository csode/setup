-- Set leader key
vim.g.mapleader = " "

-- Window navigation
vim.keymap.set("n", "<c-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<c-j>", ":wincmd j<CR>")
vim.keymap.set("n", "<c-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<c-l>", ":wincmd l<CR>")

-- Basic operations
vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>")
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>w", ":wq<CR>")
vim.keymap.set("n", "<Leader>q", "<cmd>q!<CR>", { noremap = true, silent = true })

-- Reload configuration
vim.api.nvim_set_keymap(
	"n",
	"<Leader><leader>r",
	":luafile ~/.config/nvim/init.lua<CR>",
	{ noremap = true, silent = true }
)

-- Clipboard operations
vim.api.nvim_set_keymap("v", "y", '"+y', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "yy", '"+yy', { noremap = true, silent = true })

-- Movement and selection
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Special features
vim.keymap.set("n", "|", "<cmd>Speedtyper<CR>")
vim.keymap.set("n", "<leader>zig", "<cmd>LspRestart<cr>")
vim.keymap.set("n", "Ff", vim.lsp.buf.format)
--
-- Register operations
vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set({ "n", "v" }, "<leader>d", '"_d')

-- Navigation and quickfix list
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- Error handling snippets
vim.keymap.set("n", "<leader>ee", "oif err != nil {<CR>}<Esc>Oreturn err<Esc>")
vim.keymap.set("n", "<leader>ea", 'oassert.NoError(err, "")<Esc>F";a')
vim.keymap.set("n", "<leader>el", 'oif err != nil {<CR>}<Esc>O.logger.Error("error", "error", err)<Esc>F.;i')

-- Misc mappings
vim.keymap.set("i", "<C-c>", "<Esc>")
vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>")

-- Terminal and preview mappings
vim.api.nvim_set_keymap("n", "<Esc>", ":write<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader>mp", ":vsp | terminal glow %<CR>i", { noremap = true, silent = true })
vim.api.nvim_set_keymap(
	"n",
	"<Leader>tp",
	':silent !tmux new-window "zsh -c \\"glow %; exec zsh\\"" <CR>',
	{ noremap = true, silent = true }
)

-- Navigation shortcuts
vim.api.nvim_set_keymap("n", "'", "$", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", ";", "0w", { noremap = true, silent = true })

-- Number increment function and mapping
function increment_number_in_line()
	local line = vim.api.nvim_get_current_line()
	local updated_line = line:gsub("%d+", function(num)
		local n = tonumber(num)
		return tostring(n + 1)
	end, 1)
	vim.api.nvim_set_current_line(updated_line)
end

vim.api.nvim_set_keymap("n", "<leader>;", ":lua increment_number_in_line()<CR>", { noremap = true, silent = true })

-- Cheatsheet mapping
vim.keymap.set(
	"n",
	"<leader>c",
	':lua local lang = vim.fn.input("Enter language for cheatsheet: ") lang = lang ~= "" and lang or "python" vim.cmd("silent !tmux new-window -n \'cheatsheet\' \'curl cheat.sh/" .. lang .. " && zsh\'")<CR>',
	{ noremap = true, silent = true }
)
-- Random theme switcher
vim.keymap.set("n", "<leader>tr", function()
	_G.random_theme()
end, { desc = "Random theme" })

-- Keybind to show all custom keymaps
vim.keymap.set("n", "<leader>?", function()
	require("telescope.builtin").keymaps({
		modes = { "n", "i", "v", "x", "s", "o", "t", "c" },
		show_plug = false,
	})
end, { desc = "Show all keybindings" })
vim.api.nvim_set_keymap("n", "<leader>s*", "ysiw*", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", '<leader>s"', 'ysiw"', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>ss", ":vsplit<CR>", { noremap = true, silent = true })
--
-- Go to definition
vim.api.nvim_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "gb", "<C-o>", { noremap = true, silent = true })
