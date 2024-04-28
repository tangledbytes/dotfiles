local opts = { noremap = true, silent = true }
local keymap = vim.keymap.set

-- Remap space as leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Deal with word wraps correctly
keymap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
keymap('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

keymap("", "<leader>y", "\"+y", opts)
keymap("", "<leader>p", "\"+p", opts)

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

-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

vim.cmd [[:amenu 10.100 mousemenu.Goto\ Definition <cmd>lua vim.lsp.buf.definition()<CR>]]
vim.cmd [[:amenu 10.110 mousemenu.References <cmd>lua vim.lsp.buf.references()<CR>]]
vim.keymap.set("n", "<RightMouse>", "<cmd>:popup mousemenu<CR>")
vim.keymap.set("n", "<Tab>", "<cmd>:popup mousemenu<CR>")


-- Helps getting out of terminal mode in neovim
vim.api.nvim_set_keymap('t', '<C-;>', '<C-\\><C-n>', opts)

