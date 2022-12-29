local mode_store = require("wmode.core")
local core = require("vim.core")

VimM = hs.hotkey.modal.new(Hyper, "v")
function VimM:entered()
  mode_store.set_mode("Vim", true)
  hs.alert.show("Vim normal mode")
end

function VimM:exited()
  mode_store.set_mode("Vim", nil)
  hs.alert.show("Exit Vim normal mode")
end

VimM:bind(Hyper, "v", function() VimM:exit() end)

VimM:bind("", "h", core.keyStrokeWrapped({}, "left"), nil, core.keyStrokeWrapped({}, "left"))
VimM:bind("", "j", core.keyStrokeWrapped({}, "down"), nil, core.keyStrokeWrapped({}, "down"))
VimM:bind("", "k", core.keyStrokeWrapped({}, "up"), nil, core.keyStrokeWrapped({}, "up"))
VimM:bind("", "l", core.keyStrokeWrapped({}, "right"), nil, core.keyStrokeWrapped({}, "right"))

VimM:bind("", "w", core.keyStrokeWrapped({ "alt" }, "right"), nil, core.keyStrokeWrapped({ "alt" }, "right"))
VimM:bind("", "b", core.keyStrokeWrapped({ "alt" }, "left"), nil, core.keyStrokeWrapped({ "alt" }, "left"))
