local mode_store = require("wmode.core")
local chorded = require("utils.chorded")

OpenerM = chorded.new(Hyper, "o")
OpenerM:entered(function()
	mode_store.set_mode("Opener", true)
	hs.alert.show("Opener mode")
end)
OpenerM:exited(function()
	mode_store.set_mode("Opener", nil)
	hs.alert.show("Exit Opener mode")
end)

OpenerM:bind("", "t", function() hs.application.launchOrFocus("Ghostty") end)
OpenerM:bind("", "c", function() hs.application.launchOrFocus("Visual Studio Code") end)
OpenerM:bind("", "b", function() hs.application.launchOrFocus("Arc") end)
OpenerM:bind("", "s", function() hs.application.launchOrFocus("Slack") end)
OpenerM:bind("", "m", function() hs.application.launchOrFocus("Spotify") end)
OpenerM:bind(
	"", "p",
	function()
		-- Open the URL in the private firefox window
		hs.task.new("/opt/homebrew/bin/firefox", nil, {
			"--private-window", hs.pasteboard.getContents()
		}):start()
	end
)

OpenerM:bind({}, "escape", function() OpenerM:exit() end)
