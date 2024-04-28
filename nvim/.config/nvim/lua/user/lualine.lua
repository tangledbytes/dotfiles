local M = {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		'linrongbin16/lsp-progress.nvim'
	}
}

-- Copyright (c) 2020-2021 hoob3rt
-- MIT license, see LICENSE for more details.
-- stylua: ignore
local colors = {
	black        = '#282828',
	white        = '#ebdbb2',
	red          = '#fb4934',
	green        = '#b8bb26',
	blue         = '#83a598',
	yellow       = '#fe8019',
	gray         = '#a89984',
	darkgray     = '#3c3836',
	lightgray    = '#504945',
	inactivegray = '#7c6f64',
	transparent  = nil,
}

local theme = {
	normal = {
		a = { bg = colors.gray, fg = colors.black, gui = 'bold' },
		b = { bg = colors.lightgray, fg = colors.white },
		c = { bg = colors.transparent, fg = colors.gray },
	},
	insert = {
		a = { bg = colors.blue, fg = colors.black, gui = 'bold' },
		b = { bg = colors.lightgray, fg = colors.white },
		c = { bg = colors.transparent, fg = colors.white },
	},
	visual = {
		a = { bg = colors.yellow, fg = colors.black, gui = 'bold' },
		b = { bg = colors.lightgray, fg = colors.white },
		c = { bg = colors.transparent, fg = colors.black },
	},
	replace = {
		a = { bg = colors.red, fg = colors.black, gui = 'bold' },
		b = { bg = colors.lightgray, fg = colors.white },
		c = { bg = colors.transparent, fg = colors.white },
	},
	command = {
		a = { bg = colors.green, fg = colors.black, gui = 'bold' },
		b = { bg = colors.lightgray, fg = colors.white },
		c = { bg = colors.transparent, fg = colors.black },
	},
	inactive = {
		a = { bg = colors.darkgray, fg = colors.gray, gui = 'bold' },
		b = { bg = colors.darkgray, fg = colors.gray },
		c = { bg = colors.transparent, fg = colors.gray },
	},
}


function M.config()
	require("lualine").setup({
		options = {
			theme = theme,
		},
		sections = {
			lualine_a = {},
			lualine_b = { "branch" },
			lualine_c = {
				function()
					return require('lsp-progress').progress()
				end
			},
			lualine_x = { "filetype" },
			lualine_y = { "progress" },
			lualine_z = {},
		},
		extensions = { "quickfix", "man", "fugitive", "nvim-tree" },
	})

	vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
	vim.api.nvim_create_autocmd("User", {
		group = "lualine_augroup",
		pattern = "LspProgressStatusUpdated",
		callback = require("lualine").refresh,
	})
end

return M
