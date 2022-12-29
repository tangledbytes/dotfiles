local M = {}

local default_window_title = "No longer exists"

local get_window_title_or_default = function(win, default)
  if win then
    return win:title()
  else
    if default then
      return default
    end

    return default_window_title
  end
end

M.map_windowid_to_window = function (winid)
  return hs.window.find(
    winid,
    nil,
    hs.window.filter.new():setDefaultFilter():getWindows()
  )
end

M.get_current_windowid = function ()
  local win = hs.window.focusedWindow()
  if win then
    return win:id()
  else
    return nil
  end
end

M.register_window_to_key = function (winid, key, force)
  local chord = hs.settings.get("forker") or {}
  local f = chord[key]
  local win = M.map_windowid_to_window(winid)
  if f then
    if f ~= winid then
      if force then
        chord[key] = winid
        hs.alert.show("Force forked window " .. key .. " to " .. get_window_title_or_default(win), 1)
      else
        local old_win = M.map_windowid_to_window(f)
        hs.alert.show("Reserved by " .. get_window_title_or_default(old_win) .. "", 1)
      end
    end
  else
    chord[key] = winid
    hs.alert.show("Forked window " .. key .. " to " .. get_window_title_or_default(win), 1)
  end

  hs.settings.set("forker", chord)
end

M.do_on_window = function (key, func)
  local chord = hs.settings.get("forker") or {}
  local id = chord[key]
  func(M.map_windowid_to_window(id))
end

M.pretty_text = function ()
  local chord = hs.settings.get("forker") or {}
  local windows_as_text = ""

  local chord_as_sorted_list = {}
  for k, _ in pairs(chord) do
    table.insert(chord_as_sorted_list, k)
  end
  table.sort(chord_as_sorted_list)

  for _, k in ipairs(chord_as_sorted_list) do
    local v = chord[k]
    local win = M.map_windowid_to_window(v)
    windows_as_text = windows_as_text .. k .. ": " .. get_window_title_or_default(win) .. "\n"
  end

  return windows_as_text
end

M.clear = function ()
  hs.settings.set("forker", {})
  hs.alert.show("Cleared all forked windows", 1)
end

return M