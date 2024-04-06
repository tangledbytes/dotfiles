vim.cmd("hi NormalFloat guibg=#32302F")
vim.cmd("hi FloatBorder guibg=NONE guifg=#F2E2C3")

return {
  -- devicons
  'nvim-tree/nvim-web-devicons',

  -- Themes
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("gruvbox").setup({
        terminal_colors = true, -- add neovim terminal colors
        undercurl = true,
        underline = true,
        bold = true,
        italic = {
          strings = true,
          emphasis = true,
          comments = true,
          operators = false,
          folds = true,
        },
        strikethrough = true,
        invert_selection = false,
        invert_signs = false,
        invert_tabline = false,
        invert_intend_guides = false,
        inverse = true, -- invert background for search, diffs, statuslines and errors
        contrast = "", -- can be "hard", "soft" or empty string
        palette_overrides = {},
        overrides = {},
        dim_inactive = false,
        transparent_mode = true,
      })

      vim.cmd.colorscheme('gruvbox')
    end
  },

  -- File Tree
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons'  },
    opts = {
      diagnostics = {
        enable = true,
        show_on_dirs = true,
        debounce_delay = 50,
        severity = {
          min = vim.diagnostic.severity.HINT,
          max = vim.diagnostic.severity.ERROR,
        },
        icons = {
          hint = "",
          info = "",
          warning = "",
          error = "",
        },
      },
      update_focused_file = {
        enable = true
      }
    }
  },

  -- Bufferline - skip
  {
    'akinsho/bufferline.nvim',
    version = "*",
    opts = {
      options = {
        diagnostics = 'nvim_lsp',
        mode = 'tabs',
        offsets = {
          {
            filetype = "NvimTree",
            text = "File Explorer",
            text_align = "center",
            separator = true
          }
        },
      }
    },
    dependencies = { 'nvim-tree/nvim-web-devicons', 'ellisonleao/gruvbox.nvim' },
  },

  -- Lualine
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function ()
      -- Copyright (c) 2020-2021 hoob3rt
      -- MIT license, see LICENSE for more details.
      -- stylua: ignore
      local colors = {
        black        = '#282828',
        white        = '#ebdbb2',
        red          = '#fb4934',
        green        = '#b8bb26',
        blue         = '#83a598',
        yellow       = '#fe8019',
        gray         = '#a89984',
        darkgray     = '#3c3836',
        lightgray    = '#504945',
        inactivegray = '#7c6f64',
        transparent  = nil,
      }

      local theme = {
        normal = {
          a = { bg = colors.gray, fg = colors.black, gui = 'bold' },
          b = { bg = colors.lightgray, fg = colors.white },
          c = { bg = colors.transparent, fg = colors.gray },
        },
        insert = {
          a = { bg = colors.blue, fg = colors.black, gui = 'bold' },
          b = { bg = colors.lightgray, fg = colors.white },
          c = { bg = colors.transparent, fg = colors.white },
        },
        visual = {
          a = { bg = colors.yellow, fg = colors.black, gui = 'bold' },
          b = { bg = colors.lightgray, fg = colors.white },
          c = { bg = colors.transparent, fg = colors.black },
        },
        replace = {
          a = { bg = colors.red, fg = colors.black, gui = 'bold' },
          b = { bg = colors.lightgray, fg = colors.white },
          c = { bg = colors.transparent, fg = colors.white },
        },
        command = {
          a = { bg = colors.green, fg = colors.black, gui = 'bold' },
          b = { bg = colors.lightgray, fg = colors.white },
          c = { bg = colors.transparent, fg = colors.black },
        },
        inactive = {
          a = { bg = colors.darkgray, fg = colors.gray, gui = 'bold' },
          b = { bg = colors.darkgray, fg = colors.gray },
          c = { bg = colors.transparent, fg = colors.gray },
        },
      }

      require('lualine').setup({
        options = {
          theme = theme,
        },
        extensions = {
          'quickfix',
          'nvim-tree'
        }
      })
    end,
  }
}
