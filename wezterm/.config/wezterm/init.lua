local wezterm = require('wezterm')

local M = {
	config = {}
}

if wezterm.config_builder then
	M.config = wezterm.config_builder()
end

M.load = function(path)
	require(path).init(M.config, wezterm)
end

return M
