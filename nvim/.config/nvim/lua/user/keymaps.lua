local opts = { noremap = true, silent = true }
local keymap = vim.keymap.set

--Remap space as leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Deal with word wraps correctly
keymap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
keymap('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- All Modes
keymap("", "<leader>y", "\"+y", opts)
keymap("", "<leader>p", "\"+p", opts)

-- Normal --
keymap("n", "<leader>w", ":w<CR>", opts)

keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

keymap("n", "<leader>e", ":NvimTreeToggle<CR>", opts)
keymap("n", "<", "<C-o>", opts)
keymap("n", ">", "<C-i>", opts)

-- Resize with arrows
keymap("n", "<A-j>", ":resize +2<CR>", opts)
keymap("n", "<A-k>", ":resize -2<CR>", opts)
keymap("n", "<A-l>", ":vertical resize -2<CR>", opts)
keymap("n", "<A-h>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
-- keymap("n", "<S-l>", ":bnext<CR>", opts)
-- keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)
-- keymap("v", "<leader>s", function()
--   -- Get the selected text
--   local selected = vim.fn.expand("<cword>")
--
--   -- Open a new tab
--   vim.api.nvim_command("tabnew")
--
--   -- Search for the selected text
--   vim.api.nvim_command("lgrep --exclude-dir=node_modules -r \"" .. selected .. "\" .")
--
--   -- Open the location list
--   vim.api.nvim_command("lopen")
-- end, opts)

