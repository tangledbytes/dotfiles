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
OpenerM:bind("", "b", function() hs.application.launchOrFocus("Google Chrome") end)
OpenerM:bind("", "s", function() hs.application.launchOrFocus("Slack") end)
OpenerM:bind("", "m", function() hs.application.launchOrFocus("Spotify") end)