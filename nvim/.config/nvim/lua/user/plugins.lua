local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    'git',
    'clone',
    '--depth',
    '1',
    'https://github.com/wbthomason/packer.nvim',
    install_path,
  }
  print 'Installing packer close and reopen Neovim...'
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, 'packer')
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require('packer.util').float { border = 'rounded' }
    end,
  },
}

return packer.startup(function(use)
  use 'wbthomason/packer.nvim' -- Have packer manage itself
  use 'nvim-lua/popup.nvim' -- An implementation of the Popup API from vim in Neovim
  use 'nvim-lua/plenary.nvim' -- Useful lua functions used ny lots of plugins
  use { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    requires = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      'j-hui/fidget.nvim',

      -- Additional lua configuration, makes nvim stuff amazing
      'folke/neodev.nvim',
    },
  }

  use { -- Autocompletion
    'hrsh7th/nvim-cmp',
    requires = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' },
  }

  use { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    run = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
  }

  use { -- Additional text objects via treesitter
    'nvim-treesitter/nvim-treesitter-textobjects',
    after = 'nvim-treesitter',
  }

  -- Git related plugins
  use 'tpope/vim-fugitive'
  use 'tpope/vim-rhubarb'
  use 'lewis6991/gitsigns.nvim'
  use {
    'sindrets/diffview.nvim',
    requires = 'nvim-lua/plenary.nvim'
  }

  -- Visuals
  use 'nvim-tree/nvim-web-devicons' -- Icons for everything
  use {'akinsho/bufferline.nvim', tag = "v3.*", requires = 'nvim-tree/nvim-web-devicons'}
  use { -- Vim Statusbar
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }
  use "EdenEast/nightfox.nvim" -- Theme provider for carbonfox
  use 'glepnir/dashboard-nvim' -- fancy neovim dashboard
  use "lukas-reineke/indent-blankline.nvim" -- proper indentation guide
  use 'tpope/vim-sleuth' -- Detect tabstop and shiftwidth automatically
  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      { 'nvim-tree/nvim-web-devicons', opt = false } -- optional, for file icons
    },
    tag = 'nightly' -- optional, updated every week. (see issue #1193)
  }

  -- Fuzzy Fuzzy stuff
  use { 'nvim-telescope/telescope.nvim', branch = '0.1.x', requires = { 'nvim-lua/plenary.nvim' } }   -- Fuzzy Finder (files, lsp, etc)
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make', cond = vim.fn.executable 'make' == 1 } -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available

  -- Others
  use 'numToStr/Comment.nvim' -- "gc" to comment visual regions/lines

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require('packer').sync()
  end

  -- Automatically source and re-compile packer whenever you save this init.lua
  local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
  vim.api.nvim_create_autocmd('BufWritePost', {
    command = 'source <afile> | PackerCompile',
    group = packer_group,
    pattern = vim.fn.expand '$MYVIMRC',
  })
end)
