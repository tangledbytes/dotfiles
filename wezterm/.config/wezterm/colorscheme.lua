local M = {}

M.init = function(config, wezterm)
	local colorscheme_name = 'OneHalfDark'
	local colorscheme = wezterm.get_builtin_color_schemes()[colorscheme_name]
	colorscheme.background = 'black'
	colorscheme.brights[1] = '#928374'

	config.color_schemes = {
		[colorscheme_name] = colorscheme
	}
	config.color_scheme = colorscheme_name
end

return M
