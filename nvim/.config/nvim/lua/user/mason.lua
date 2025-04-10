local M = {
	"williamboman/mason-lspconfig.nvim",
	dependencies = {
		"williamboman/mason.nvim",
	},
}

function M.config()
	local servers = {
		"cssls",
		"html",
		-- "ts_ls",
		"bashls",
		"jsonls",
		"clangd",
		"gopls",
		"rust_analyzer",
		"lua_ls",
		"tsserver",
		"zls",
	}

	require("mason").setup({
		ui = {
			border = "rounded",
		},
	})

	require("mason-lspconfig").setup({
		ensure_installed = servers,
	})
end

return M
