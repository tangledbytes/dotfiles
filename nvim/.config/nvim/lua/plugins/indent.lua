return {
  -- proper indentation guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = 'ibl',
    opts = {
      scope = { enabled = false},
      exclude = {
        filetypes = {
          'lspinfo',
          'packer',
          'checkhealth',
          'help',
          'man',
          'dashboard',
          '',
        },
        -- filetypes = vim.g.exclude_filetypes,
      },
    }
  }
}
