local M = {}

M.init = function(config)
	config.window_background_opacity = 0.80
	config.macos_window_background_blur = 75
	config.window_decorations = "RESIZE"
	config.window_padding = {
	  left = 12,
	  right = 12,
	  top = 8,
	  bottom = 0,
	}
	config.enable_scroll_bar = true
end

return M
