-- local colorscheme = "nightfox"
--
-- require('nightfox').setup({
--   options = {
--     transparent = true,
--   }
-- })
--
--
-- local colorscheme = "onedark"
--
-- require("onedark").setup({
--   style = "darker",
--   transparent = true,
--   lualine = {
--     transparent = true,
--   }
-- })
--
local colorscheme = "gruvbox"
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
  dim_inactive = true,
  transparent_mode = true,
})

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  vim.notify("colorscheme " .. colorscheme .. " not found!")
  return
end
