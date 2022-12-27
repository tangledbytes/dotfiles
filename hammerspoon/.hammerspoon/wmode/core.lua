---@diagnostic disable-next-line: lowercase-global
_modes = {}

local M = {}

M.set_mode = function(mode, val)
  _modes[mode] = val
  if M.cb then
    M.cb()
  end
end

M.get_modes = function(none, trim)
  local modes_text = ""
  for k, _ in pairs(_modes) do
    if trim then
      k = k:sub(1, 1)
    end
    modes_text = modes_text .. k .. ", "
  end

  if modes_text == "" then
    if none then
      modes_text = none
    else
      modes_text = "No Active Modes"
    end
  else
    modes_text = "Modes: " .. modes_text:sub(1, -3)
  end

  return modes_text
end

M.show_modes = function()
  hs.alert.show(M.get_modes(), 0.5)
end

M.set_cb = function(fn)
  M.cb = fn
end

return M