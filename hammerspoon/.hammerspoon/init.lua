Hyper = { "ctrl", "shift", "cmd", "alt" }

hs.window.animationDuration = 0

hs.hotkey.bind(Hyper, "R", function()
  hs.reload()
end)

require("switcher")
require("window")
require("spotify")
require("opener")
require("wmode")
require("picker")
require("vim")
require("forker")