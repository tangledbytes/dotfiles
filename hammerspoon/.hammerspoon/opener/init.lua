local mode_store = require("wmode.core")

OpenerM = hs.hotkey.modal.new(Hyper, "o")
function OpenerM:entered()
	mode_store.set_mode("Opener", true)
	hs.alert.show("Opener mode")
end
function OpenerM:exited()
	mode_store.set_mode("Opener", nil)
	hs.alert.show("Exit Opener mode")
end
OpenerM:bind(Hyper, "o", function() OpenerM:exit() end)

OpenerM:bind("", "t", function() hs.application.launchOrFocus("iTerm") end)
OpenerM:bind("", "c", function() hs.application.launchOrFocus("Visual Studio Code") end)