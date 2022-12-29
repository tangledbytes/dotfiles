local core = require("forker.core")
local mode_store = require("wmode.core")
local chorded = require("utils.chorded")

local primary = { "shift" }
local secondary = { "cmd", "shift" }

local function display_forked_windows()
	local windows_as_text = "Forked Windows\n\n" .. core.pretty_text()
	hs.alert.show(windows_as_text, 3)
end

ForkerM = chorded.new(Hyper, "f")
ForkerM:entered(function ()
	mode_store.set_mode("Forker", true)
	hs.settings.set("forker.display_entry_uuid", hs.alert.show("Entered forker: Waiting for the chord", ""))
end)

ForkerM:exited(function ()
	mode_store.set_mode("Forker", nil)

	-- Clear out the main text
	local main_text_uuid = hs.settings.get("forker.display_entry_uuid")
	if main_text_uuid then
		hs.alert.closeSpecific(main_text_uuid)
		hs.settings.set("forker.display_entry_uuid", nil)
	end
end)

ForkerM:bind("", "escape", function() ForkerM:exit() end)

for i = 1, 9 do
	ForkerM:bind(primary, tostring(i), function() core.register_window_to_key(core.get_current_windowid(), tostring(i)) end)
end
for i = 1, 9 do
	ForkerM:bind(secondary, tostring(i),
		function() core.register_window_to_key(core.get_current_windowid(), tostring(i), true) end)
end
for i = 1, 26 do
	ForkerM:bind(primary, string.char(96 + i),
		function() core.register_window_to_key(core.get_current_windowid(), string.char(96 + i)) end)
end
for i = 1, 26 do
	ForkerM:bind(secondary, string.char(96 + i),
		function() core.register_window_to_key(core.get_current_windowid(), string.char(96 + i), true) end)
end

for i = 1, 9 do
	ForkerM:bind("", tostring(i), function() core.do_on_window(tostring(i), function(win)
			if win then
				win:focus()
			else
				hs.alert.show("No window is forked to " .. string.char(96 + i) .. "", 1)
			end

			-- Exit the chord mode after performing the action
			ForkerM:exit()
		end)
	end)
end
for i = 1, 26 do
	ForkerM:bind("", string.char(96 + i), function() core.do_on_window(string.char(96 + i), function(win)
			if win then
				win:focus()
			else
				hs.alert.show("No window is forked to " .. string.char(96 + i) .. "", 1)
			end

			-- Exit the chord mode after performing the action
			ForkerM:exit()
		end)
	end)
end

ForkerM:bind("", "f1", display_forked_windows)
ForkerM:bind("", "f2", core.clear)
