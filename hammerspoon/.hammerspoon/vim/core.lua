local M = {}

M.keyStroke = function(mods, key)
  return hs.eventtap.keyStroke(mods, key, 1)
end

M.keyStrokeWrapped = function(mods, key)
  return function()
    M.keyStroke(mods, key)
  end
end

return M