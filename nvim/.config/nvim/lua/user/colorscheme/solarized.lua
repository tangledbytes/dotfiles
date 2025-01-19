local M = {
	"Tsuzat/NeoSolarized.nvim",
	lazy = false,
	priority = 1000,
}

function M.config()
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

return M
