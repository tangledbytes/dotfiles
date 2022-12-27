local core = require("wmode.core")

---@diagnostic disable-next-line: lowercase-global
wmode = hs.menubar.new()
wmode:setTitle(core.get_modes("NAF"))
core.set_cb(function()
	wmode:setTitle(core.get_modes("NAF", true))
end)

hs.hotkey.bind(Hyper, "space", core.show_modes)