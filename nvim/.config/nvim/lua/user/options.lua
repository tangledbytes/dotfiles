vim.opt.backup = false                          -- creates a backup file
vim.opt.cmdheight = 1                           -- more space in the neovim command line for displaying messages
vim.opt.completeopt = { "menuone", "noselect" } -- mostly just for cmp
vim.opt.conceallevel = 0                        -- so that `` is visible in markdown files
vim.opt.fileencoding = "utf-8"                  -- the encoding written to a file
vim.opt.hlsearch = true                         -- highlight all matches on previous search pattern
vim.opt.ignorecase = true                       -- ignore case in search patterns
vim.opt.mouse = "a"                             -- allow the mouse to be used in neovim
vim.opt.breakindent = true                      -- Enable break indent
vim.opt.pumheight = 10                          -- pop up menu height
vim.opt.pumblend = 0                            -- Enables transparency in the popup menus (0%)
vim.opt.showmode = false                        -- we don't need to see things like -- INSERT -- anymore
vim.opt.showtabline = 1                         -- always show tabs
vim.opt.smartcase = true                        -- smart case
vim.opt.smartindent = true                      -- make indenting smarter again
vim.opt.splitbelow = true                       -- force all horizontal splits to go below current window
vim.opt.splitright = true                       -- force all vertical splits to go to the right of current window
vim.opt.swapfile = false                        -- creates a swapfile
vim.opt.termguicolors = true                    -- set term gui colors (most terminals support this)
vim.opt.timeoutlen = 250                        -- time to wait for a mapped sequence to complete (in milliseconds)
vim.opt.undofile = true                         -- enable persistent undo
vim.opt.updatetime = 200                        -- faster completion (4000ms default)
vim.opt.writebackup = false                     -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
vim.opt.number = true                           -- set numbered lines
vim.opt.relativenumber = false                   -- set relative numbered lines
vim.opt.signcolumn = "yes"                      -- always show the sign column, otherwise it would shift the text each time
vim.opt.wrap = false                            -- display lines as one long line
vim.opt.scrolloff = 8                           -- is one of my fav
vim.opt.sidescrolloff = 8
vim.opt.fillchars = {eob = " "}                 -- Removes the weird ~ characters
vim.opt.cursorline = true                       -- Highlight cursorline
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false

vim.g.netrw_banner = 0
vim.g.netrw_mouse = 2
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- # Neovide specific options
vim.g.neovide_hide_mouse_when_typing = true     -- hide mouse when typing
vim.g.neovide_remember_window_size = true       -- remember window size
vim.g.neovide_transparency = 0.75
vim.g.neovide_window_blurred = true
-- vim.g.neovide_input_macos_alt_is_meta = true    -- fix alt key

vim.cmd("set whichwrap+=<,>,[,],h,l")
vim.cmd([[set iskeyword+=-]])

vim.cmd([[set listchars=tab:>=,trail:.,space:.]])

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
	group = highlight_group,
	pattern = '*',
	callback = function()
		vim.highlight.on_yank({
			higroup = 'IncSearch',
			timeout = 40,
		})
	end,
})

local indentchars_group = vim.api.nvim_create_augroup('FileTypeSettings', { clear = true })
local listfts = { javascript = true, typescript = true }
vim.api.nvim_create_autocmd('BufEnter',{
	group = indentchars_group,
	pattern = '*',
	callback = function()
		local ft = vim.bo.filetype
		if listfts[ft] ~= nil then
			vim.opt_local.list = true
		end
	end
})
