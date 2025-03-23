-- Basic vim settings
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.g.mapleader = " "
vim.g.background = "light"
vim.o.laststatus = 0

-- General options
vim.opt.guicursor = ""
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false

-- File handling
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- Search settings
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Visual settings
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")
vim.opt.updatetime = 50
vim.opt.colorcolumn = ""

-- Status line settings
vim.o.laststatus = 2 -- Always show the statusline
vim.o.cursorline = true

-- Git branch function for status line
function GitBranch()
    local handle = io.popen("git rev-parse --abbrev-ref HEAD 2>/dev/null")
    local result = handle:read("*a") or ""
    handle:close()
    result = result:gsub("\n", "") -- Remove newline
    return result ~= "" and "Git branch - " .. result or ""
end

-- Status line configuration
vim.cmd("highlight StatusLine guifg=#FFFFFF ctermfg=15")
vim.o.statusline = "%#StatusLine# %t %m %y %{v:lua.GitBranch()} [%l/%L] %p%%"
