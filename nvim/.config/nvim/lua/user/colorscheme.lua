local GruvBox =   {
	"ellisonleao/gruvbox.nvim",
	lazy = false,
	priority = 1000,
}

function GruvBox.config()
	require("gruvbox").setup({
		terminal_colors = true, -- add neovim terminal colors
		undercurl = true,
		underline = true,
		bold = true,
		italic = {
		  strings = true,
		  emphasis = true,
		  comments = true,
		  operators = false,
		  folds = true,
		},
		strikethrough = true,
		invert_selection = false,
		invert_signs = false,
		invert_tabline = false,
		invert_intend_guides = false,
		inverse = true, -- invert background for search, diffs, statuslines and errors
		contrast = "", -- can be "hard", "soft" or empty string
		palette_overrides = {},
		overrides = {},
		dim_inactive = false,
		transparent_mode = true,
	})

	vim.cmd.colorscheme('gruvbox')
end

local Solarized = {
	"Tsuzat/NeoSolarized.nvim",
	lazy = false,
	priority = 1000,
}

function Solarized.config()
	require("NeoSolarized").setup({
		style = "dark",
		transparent = true,
		terminal_colors = true,
		enable_italics = true,
		styles = {
			comments = { italic = true },
			keywords = { italic = true },
			functions = { bold = true },
			variables = {},
			string = { italic = true },
			underline = true, -- true/false; for global underline
			undercurl = true, -- true/false; for global undercurl
		},
	})

	vim.cmd.colorscheme('NeoSolarized')
end

local SolarizedOsaka = {
	"craftzdog/solarized-osaka.nvim",
	lazy = false,
	priority = 1000,
	opts = {},
}

function SolarizedOsaka.config()
	require("solarized-osaka").setup({
		transparent = true,
		terminal_colors = true,
		styles = {
			comments = { italic = true },
			keywords = { italic = true },
			functions = {},
			variables = {},
			sidebars = "dark",
			floats = "dark",
		},
		sidebars = { "qf", "help" },
		day_brightness = 0.3,
		hide_inactive_statusline = false,
		dim_inactive = false,
		lualine_bold = false,
	})

	vim.cmd.colorscheme('solarized-osaka')
end

return GruvBox
