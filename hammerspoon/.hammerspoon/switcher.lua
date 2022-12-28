all_window_switcher = hs.window.switcher.new(hs.window.filter.new():setCurrentSpace():setDefaultFilter{})

-- Bind alt+tab and alt+shift+tab to switch between window
hs.hotkey.bind({"alt"}, "tab", function()
  all_window_switcher:next()
end)
hs.hotkey.bind({"alt", "shift"}, "tab", function()
  all_window_switcher:previous()
end)