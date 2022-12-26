-- Fork will fork/unfork the current window using hyper+f1,hyper+f2, etc. such that the set of forked windows
-- will be accessible via hyper+1, hyper+2, etc.

-- Debugging
hs.hotkey.bind(hyper, "f10", function()
  hs.settings.set("forked", nil)
  hs.alert.show("Cleared forked windows", 0.25)
end)

-- Fork the current window.
local function fork(n)
  local win = hs.window.focusedWindow()
  local forked = hs.settings.get("forked") or {}

  local f = forked[n]
  if f then
    -- If the same window is already forked, unfork it.
    if f == win:id() then
      forked[n] = nil
      hs.alert.show("Unforked window " .. tostring(n), 0.25)
    else
      -- If a different window is forked, overwrite it.
      forked[n] = win:id()
      hs.alert.show("Forked window " .. tostring(n) .. " to " .. win:title(), 0.25)
    end

  else
    -- If no window is forked, fork it.
    forked[n] = win:id()
    hs.alert.show("Forked window " .. tostring(n) .. " to " .. win:title(), 0.25)
  end

  hs.settings.set("forked", forked)
end

for i = 1, 9 do
  hs.hotkey.bind(hyper, "f" .. tostring(i), function()fork(tostring(i))end)
end

-- Bind hyper+1, hyper+2, etc. to switch to forked windows.
local function switch_to_forked(n)
  local forked = hs.settings.get("forked") or {}
  local id = forked[n]
  if id then
    local win = hs.window.find(id, nil, hs.window.filter.new():setCurrentSpace():setDefaultFilter():getWindows())
    if win then
      win:focus()
    else
      forked[n] = nil
      hs.settings.set("forked", forked)
      hs.alert.show("Forked window " .. tostring(n) .. " no longer exists", 0.25)
    end
  else
    hs.alert.show("No window forked to " .. tostring(n), 0.25)
  end
end

for i = 1, 9 do
  hs.hotkey.bind(hyper, tostring(i), function()switch_to_forked(tostring(i))end)
end