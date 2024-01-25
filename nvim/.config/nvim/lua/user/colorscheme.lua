-- local colorscheme = "nightfox"
--
-- require('nightfox').setup({
--   options = {
--     transparent = true,
--   }
-- })
--
local colorscheme = "onedark"
require("onedark").setup({
  style = "darker",
  transparent = true,
  lualine = {
    transparent = true,
  }
})

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  vim.notify("colorscheme " .. colorscheme .. " not found!")
  return
end
