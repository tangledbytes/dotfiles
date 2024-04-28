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
		"tsserver",
		"bashls",
		"jsonls",
		"clangd",
		"gopls",
		"rust_analyzer",
		"tsserver",
		"lua_ls",
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
