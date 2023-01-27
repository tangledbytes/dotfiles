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

VimM:bind("", "p", function() hs.eventtap.keyStrokes(hs.pasteboard.getContents()) end)

VimM:bind("", "w", core.keyStrokeWrapped({ "alt" }, "right"), nil, core.keyStrokeWrapped({ "alt" }, "right"))
VimM:bind("", "b", core.keyStrokeWrapped({ "alt" }, "left"), nil, core.keyStrokeWrapped({ "alt" }, "left"))

VimM:bind("", "u", core.keyStrokeWrapped({ "cmd" }, "z"), nil, core.keyStrokeWrapped({ "cmd" }, "z"))
VimM:bind("", "r", core.keyStrokeWrapped({ "cmd", "shift" }, "z"), nil, core.keyStrokeWrapped({ "cmd", "shift" }, "z"))

VimM:bind({"ctrl"}, "d", core.keyStrokeWrapped({}, "pagedown"), nil, core.keyStrokeWrapped({}, "pagedown"))
VimM:bind({"ctrl"}, "u", core.keyStrokeWrapped({}, "pageup"), nil, core.keyStrokeWrapped({}, "pageup"))

VimM:bind({ "rightshift" }, ",", core.keyStrokeWrapped({ "cmd" }, "left"), nil, core.keyStrokeWrapped({ "cmd" }, "left"))
VimM:bind({ "rightshift" }, ".", core.keyStrokeWrapped({ "cmd" }, "right"), nil, core.keyStrokeWrapped({ "cmd" }, "right"))