visible_window_switcher = hs.window.switcher.new()
all_window_switcher = hs.window.switcher.new(hs.window.filter.new():setCurrentSpace():setDefaultFilter{})
all_window_current_space_switcher = hs.window.switcher.new(hs.window.filter.new():setCurrentSpace(true):setDefaultFilter())

-- Bind alt+tab and alt+shift+tab to switch between window
hs.hotkey.bind({"alt"}, "tab", function()
  visible_window_switcher:next()
end)
hs.hotkey.bind({"alt", "shift"}, "tab", function()
  visible_window_switcher:previous()
end)

-- Bind alt+` and alt+shift+` to switch between ALL windows
hs.hotkey.bind({"alt"}, "`", function()
  all_window_switcher:next()
end)
hs.hotkey.bind({"alt", "shift"}, "`", function()
  all_window_switcher:previous()
end)

-- Bind alt+0 and alt+shift+0 to switch between ALL windows in current space
hs.hotkey.bind({"alt"}, "0", function()
  all_window_current_space_switcher:next()
end)
hs.hotkey.bind({"alt", "shift"}, "0", function()
  all_window_current_space_switcher:previous()
end)

-- Custom window switcher
-- switcher for chrome only - will help to switch between chrome tabs instantly
custom_switcher_1 = hs.window.switcher.new({
  "Google Chrome"
})

-- switcher for vscode only - will help to switch between vscode tabs instantly
custom_switcher_2 = hs.window.switcher.new({
  "Code"
})

-- switcher for iterm2 only - will help to switch between iterm2 tabs instantly
custom_switcher_3 = hs.window.switcher.new({
  "iTerm2"
})

-- switcher for slack only - will help to switch between slack tabs instantly
custom_switcher_4 = hs.window.switcher.new({
  "Slack"
})

-- Bind alt+1 and alt+shift+1 to switch between custom window
-- chrome only
hs.hotkey.bind({"alt"}, "1", function()
  custom_switcher_1:next()
end)
hs.hotkey.bind({"alt", "shift"}, "1", function()
  custom_switcher_1:previous()
end)

-- Bind alt+2 and alt+shift+2 to switch between custom window
-- vscode only
hs.hotkey.bind({"alt"}, "2", function()
  custom_switcher_2:next()
end)
hs.hotkey.bind({"alt", "shift"}, "2", function()
  custom_switcher_2:previous()
end)

-- Bind alt+3 and alt+shift+3 to switch between custom window
-- iterm2 only
hs.hotkey.bind({"alt"}, "3", function()
  custom_switcher_3:next()
end)
hs.hotkey.bind({"alt", "shift"}, "3", function()
  custom_switcher_3:previous()
end)

-- Bind alt+4 and alt+shift+4 to switch between custom window
-- slack only
hs.hotkey.bind({"alt"}, "4", function()
  custom_switcher_4:next()
end)
hs.hotkey.bind({"alt", "shift"}, "4", function()
  custom_switcher_4:previous()
end)
