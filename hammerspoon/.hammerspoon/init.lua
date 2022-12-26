hyper = {"ctrl", "shift", "cmd", "alt"}
hs.window.animationDuration = 0
hs.hotkey.bind(hyper, "R", function()
  hs.reload()
end)

require("switcher")
require("window")
require("fork")