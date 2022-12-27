local core = require("fork.core")
local mode_store = require("wmode.core")
local forked_display = core.display_forked_windows()

ForkM = hs.hotkey.modal.new(Hyper, "f")
function ForkM:entered()
	mode_store.set_mode("Fork", true)
	hs.alert.show("Fork mode")
end
function ForkM:exited()
	mode_store.set_mode("Fork", nil)
	hs.alert.show("Exit Fork mode")
end
ForkM:bind(Hyper, "f", function() ForkM:exit() end)

for i = 1, 9 do
  ForkM:bind("", "f" .. tostring(i), function() core.fork(tostring(i)) end)
end
for i = 1, 9 do
  ForkM:bind("shift", "f" .. tostring(i), function() core.fork(tostring(i), true) end)
end
ForkM:bind("", "f10", forked_display)
ForkM:bind("", "f12", function()
  hs.settings.set("forked", nil)
  hs.alert.show("Cleared forked windows", 0.5)
end)

for i = 1, 9 do
  hs.hotkey.bind("alt", "f" .. tostring(i), function() core.switch_to_forked(tostring(i)) end)
end
