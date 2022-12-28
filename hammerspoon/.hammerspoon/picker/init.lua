local pickers = require("picker.core")
local fs = require("picker.fs")
local scripts = require("picker.scripts")

pickers.register_picker("home_search", function(tbl)
  if tbl == nil then return end
  scripts.osascript_open_directory_in_iterm(tbl["text"])
end, "Search in $HOME")

pickers.picker_register_query_changed_callback(
	"home_search",
	fs.get_fs_debounced(pickers.choice_fn_for_picker("home_search"), "~", "d", "4")
)


pickers.register_picker("dev_search", function(tbl)
  if tbl == nil then return end
  scripts.osascript_open_directory_in_iterm(tbl["text"])
end, "Search in ~/dev")

pickers.picker_register_query_changed_callback(
	"dev_search",
	fs.get_fs_debounced(pickers.choice_fn_for_picker("dev_search"), "$HOME/dev", "d", "3")
)

hs.hotkey.bind(Hyper, "J", function()
	pickers.show_picker("home_search")
end)
hs.hotkey.bind(Hyper, "K", function()
	pickers.show_picker("dev_search")
end)