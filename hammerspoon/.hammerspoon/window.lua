-- Bind hyper+W to set window to full screen
hs.hotkey.bind(Hyper, "W", function()
  hs.window.focusedWindow():toggleFullScreen()
end)

-- Bind hyper+M to set window to minimize
hs.hotkey.bind(Hyper, "M", function()
  local win = hs.window.focusedWindow()

  if win:isMinimized() then
    win:unminimize()
  else
    win:minimize()
  end
end)