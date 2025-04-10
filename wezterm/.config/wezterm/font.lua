local M = {}

M.init = function(config, wezterm)
	config.font_size = 14
	config.font = wezterm.font_with_fallback({
		{ family = "Cascadia Code", weight = "DemiBold" },
		{ family = "Symbols Nerd Font Mono" },
	})
end

return M
