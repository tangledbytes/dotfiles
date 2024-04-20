return {
  "ray-x/go.nvim",
  dependencies = {  -- optional packages
    "ray-x/guihua.lua",
    "neovim/nvim-lspconfig",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    local format_sync_grp = vim.api.nvim_create_augroup("goimports", {})
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*.go",
      callback = function()
       require('go.format').goimports()
      end,
      group = format_sync_grp,
    })

    require("go").setup({
      lsp_keymaps = false,
      lsp_cfg = {
        settings = {
          gopls = {
            analyses = {
              fieldalignment = true,
              shadow = true,
            },
            annotations = {
              bounds = true,
              escape = true,
              inline = true,
              ['nil'] = true,
            },
            codelenses = {
              gc_details = true,
            },
            gofumpt = true,
            staticcheck = true,
          }
        },
      }
    })
  end,
  event = { "CmdlineEnter" },
  ft = { "go", "gomod" },
}
