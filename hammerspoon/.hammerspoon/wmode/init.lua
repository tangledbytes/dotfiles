local core = require("wmode.core")

---@diagnostic disable-next-line: lowercase-global
wmode = hs.menubar.new()
wmode:setTitle(core.get_modes("NAM"))
core.set_cb(function()
	wmode:setTitle(core.get_modes("NAM", true))
end)

-- hs.hotkey.bind(Hyper, "space", core.show_modes)