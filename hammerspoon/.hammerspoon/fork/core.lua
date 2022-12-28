local M = {}

-- Find a window by id.
local function find_window(id)
  return hs.window.find(
    id,
    nil,
    hs.window.filter.new():setDefaultFilter({}):getWindows()
  )
end

-- Fork the current window.
M.fork = function(n, force)
  local win = hs.window.focusedWindow()
  local forked = hs.settings.get("forked") or {}

  local f = forked[n]
  if f then
    if f ~= win:id() then
      if force then
        forked[n] = win:id()
        hs.alert.show("Force forked window " .. tostring(n) .. " to " .. win:title(), 1)
      else
        local old_win = find_window(f)
        hs.alert.show("Reserved by " .. old_win:title() .. "", 1)
      end
    end
  else
    forked[n] = win:id()
    hs.alert.show("Forked window " .. tostring(n) .. " to " .. win:title(), 1)
  end

  hs.settings.set("forked", forked)
end

-- get_forked_windows returns a formatted string with the list of forked windows.
M.get_forked_windows =  function()
  local forked = hs.settings.get("forked") or {}
  local windows_as_text = "FORKED WINDOWS\n\n"

  local forked_as_sorted_list = {}
  for k, v in pairs(forked) do
    table.insert(forked_as_sorted_list, k)
  end
  table.sort(forked_as_sorted_list)

  for _, k in ipairs(forked_as_sorted_list) do
    local v = forked[k]
    local win = find_window(v)
    if win then
      windows_as_text = windows_as_text .. k .. ": " .. win:title() .. "\n"
    else
      windows_as_text = windows_as_text .. k .. ": " .. "No longer exists" .. "\n"
    end
  end

  return windows_as_text
end

-- switch_to_forked switches to the forked window with the given number.
M.switch_to_forked = function(n)
  local forked = hs.settings.get("forked") or {}
  local id = forked[n]
  if id then
    local win = find_window(id)
    if win then
      win:focus()
    else
      hs.alert.show("Forked window " .. tostring(n) .. " no longer exists", 1)
    end
  else
    hs.alert.show("No window forked to " .. tostring(n), 1)
  end
end

-- display_forked_windows returns a function that displays the list of forked windows.
M.display_forked_windows = function()
  local uuid = nil

  return function()
    if uuid then
      hs.alert.closeSpecific(uuid)
      uuid = nil
      return
    end

    local windows_as_text = M.get_forked_windows()
    uuid = hs.alert.show(windows_as_text, "")
  end
end

return M