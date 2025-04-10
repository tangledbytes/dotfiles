local util = require('util')

local M = {}
M.init = function(config, wezterm)
	local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")

	local os = util.getOS()
	if os == 'OSX' or os == 'Darwin' then
		workspace_switcher.zoxide_path = '/opt/homebrew/bin/zoxide'
	end

	table.insert(
		config.keys,
		{
			key = "k",
			mods = "LEADER|CTRL",
			action = workspace_switcher.switch_workspace(),
		}
	)
end

return M
