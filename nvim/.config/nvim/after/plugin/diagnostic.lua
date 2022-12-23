vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>de', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>dq', vim.diagnostic.setloclist)
