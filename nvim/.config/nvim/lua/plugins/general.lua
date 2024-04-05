return {
  'tpope/vim-sleuth', -- Auto tabstop detection, etc
  'nvim-lua/popup.nvim', -- An implementation of the Popup API from vim in Neovim
  'nvim-lua/plenary.nvim', -- Useful lua functions used ny lots of plugins
  { 'numToStr/Comment.nvim', opts = {} }, -- "gc" to comment visual regions/lines

  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
}
