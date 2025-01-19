local M = {
	'navarasu/onedark.nvim'
}

function M.config()
	local onedark = require('onedark')

	onedark.setup({
		style = 'darker',
		transparent = true,
		term_colors = true,

		-- Lualine options --
		lualine = {
			transparent = true, -- lualine center bar transparency
		},
	})
	onedark.load()
end

return M
