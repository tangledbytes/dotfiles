local opts = { noremap = true, silent = true }
local term_opts = { silent = true }
local keymap = vim.keymap.set

--Remap space as leader key
keymap({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Deal with word wraps correctly
keymap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
keymap('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- All Modes
keymap("", "<leader>y", "\"+y", opts)
keymap("", "<leader>p", "\"+p", opts)

-- Normal --
-- Better window navigation
-- keymap("n", "<C-h>", "<C-w>h", opts)
-- keymap("n", "<C-j>", "<C-w>j", opts)
-- keymap("n", "<C-k>", "<C-w>k", opts)
-- keymap("n", "<C-l>", "<C-w>l", opts)

keymap("n", "<leader>e", ":NvimTreeToggle<CR>", opts)
keymap("n", "<", "<C-o>", opts)
keymap("n", ">", "<C-i>", opts)

-- Resize with arrows
-- keymap("n", "<S-j>", ":resize +2<CR>", opts)
-- keymap("n", "<S-k>", ":resize -2<CR>", opts)
-- keymap("n", "<S-l>", ":vertical resize -2<CR>", opts)
-- keymap("n", "<S-h>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
-- keymap("n", "<S-l>", ":bnext<CR>", opts)
-- keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Insert --
-- None for now

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)
keymap("v", "<leader>s", function()
  -- Get the selected text
  local selected = vim.fn.expand("<cword>")

  -- Open a new tab
  vim.api.nvim_command("tabnew")

  -- Search for the selected text
  vim.api.nvim_command("lgrep --exclude-dir=node_modules -r \"" .. selected .. "\" .")

  -- Open the location list
  vim.api.nvim_command("lopen")
end, opts)

-- Move text up and down
-- keymap("v", "<A-j>", ":m .+1<CR>==", opts)
-- keymap("v", "<A-k>", ":m .-2<CR>==", opts)
-- keymap("v", "p", '"_dP', opts)

-- Visual Block --
-- Move text up and down
-- keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
-- keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Terminal --
-- Better terminal navigation
-- keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
-- keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
-- keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
-- keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)
keymap("t", "<leader>n", "<CMD><CR>", {})
