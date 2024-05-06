local M = {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		{
			"folke/neodev.nvim",
		},
	},
}

local function local_lsp_cfg(server)
	local f = loadfile(vim.fn.getcwd() .. '/.lspconfig.lua')

	if f ~= nil then
		local lcfg = f()
		if lcfg ~= nil then
			return lcfg[server]
		end
	end

	return nil
end

local function lsp_keymaps()
	vim.api.nvim_create_autocmd('LspAttach', {
		group = vim.api.nvim_create_augroup('utk-lsp-keymap-attach', { clear = true }),
		callback = function(event)
			local map = function(keys, func, desc)
				vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
			end

			-- Jump to the definition of the word under your cursor.
			-- This is where a variable was first declared, or where a function is defined, etc.
			-- To jump back, press <C-t>.
			map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

			-- Find references for the word under your cursor.
			map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

			-- Jump to the implementation of the word under your cursor.
			-- Useful when your language has ways of declaring types without an actual implementation.
			map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

			-- Jump to the type of the word under your cursor.
			-- Useful when you're not sure what type a variable is and you want to see
			-- the definition of its *type*, not where it was *defined*.
			map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinitions')

			-- Fuzzy find all the symbols in your current document.
			-- Symbols are things like variables, functions, types, etc.
			map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

			-- Fuzzy find all the symbols in your current workspace.
			-- Similar to document symbols, except searches over your entire project.
			map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

			-- Rename the variable under your cursor.
			-- Most Language Servers support renaming across files, etc.
			map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

			-- Execute a code action, usually your cursor needs to be on top of an error
			-- or a suggestion from your LSP for this to activate.
			map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

			-- Runs codelens on the current line
			map('<leader>cla', vim.lsp.codelens.run, 'Run Code[L]ens Action')

			-- Toggles the inlay hints
			map('<leader>ih', require('user.lspconfig').toggle_inlay_hints, 'Toggle [I]nlay [H]ints')

			-- Go to the next diagnostic
			map('<leader>dn', vim.diagnostic.goto_next, '[D]iagnostic [N]ext')

			-- Go to the previous diagnostic
			map('<leader>dp', vim.diagnostic.goto_prev, '[D]iagnostic [P]revious')

			-- Add diagnostic items to quickfix list
			map('<leader>dq', vim.diagnostic.setloclist, '[D]iagnostic [Q]uickfix')

			-- Opens a popup that displays documentation about the word under your cursor
			-- See `:help K` for why this keymap.
			map('K', vim.lsp.buf.hover, 'Hover Documentation')

			-- WARN: This is not Goto Definition, this is Goto Declaration.
			-- For example, in C this would take you to the header.
			map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

			map('<leader>sws', function()
				vim.ui.select({
					'File',
					'Module',
					'Namespace',
					'Package',
					'Class',
					'Method',
					'Property',
					'Field',
					'Constructor',
					'Enum',
					'Interface',
					'Function',
					'Variable',
					'Constant',
					'String',
					'Number',
					'Boolean',
					'Array',
					'Object',
					'Key',
					'Null',
					'EnumMember',
					'Struct',
					'Event',
					'Operator',
					'TypeParameter',
				}, { prompt = 'Select symbol kind' },
				function (choice)
					require('telescope.builtin').lsp_dynamic_workspace_symbols({ symbols = choice })
				end)
			end, '[S]earch [W]orkspace [S]ymbols')

			-- The following two autocommands are used to highlight references of the
			-- word under your cursor when your cursor rests there for a little while.
			--    See `:help CursorHold` for information about when this is executed
			--
			-- When you move your cursor, the highlights will be cleared (the second autocommand).
			local client = vim.lsp.get_client_by_id(event.data.client_id)
			if client and client.server_capabilities.documentHighlightProvider then
				vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
					buffer = event.buf,
					callback = vim.lsp.buf.document_highlight,
				})

				vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
					buffer = event.buf,
					callback = vim.lsp.buf.clear_references,
				})
			end

        end,
      })
end

local function lsp_user_commands()
	vim.api.nvim_create_autocmd('LspAttach', {
		group = vim.api.nvim_create_augroup('utk-lsp-attach-usercmds', { clear = true }),
		callback = function(event)
			vim.api.nvim_buf_create_user_command(event.buf, 'Format', function(_)
				vim.lsp.buf.format()
			end, { desc = 'Format current buffer with LSP' })
		end
	})
end

M.on_attach = function(client, bufnr)
	if client.supports_method "textDocument/inlayHint" then
		-- TODO: Fix this
		-- vim.lsp.inlay_hint.enable(bufnr, true)
	end
end

function M.common_capabilities()
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities.textDocument.completion.completionItem.snippetSupport = true
	return capabilities
end

M.toggle_inlay_hints = function()
	local bufnr = vim.api.nvim_get_current_buf()
	vim.lsp.inlay_hint.enable(bufnr, not vim.lsp.inlay_hint.is_enabled(bufnr))
end

function M.config()
	lsp_keymaps()
	lsp_user_commands()

	local lspconfig = require "lspconfig"
	local icons = require "user.icons"

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

	local default_diagnostic_config = {
		signs = {
			active = true,
			values = {
				{ name = "DiagnosticSignError", text = icons.diagnostics.Error },
				{ name = "DiagnosticSignWarn", text = icons.diagnostics.Warning },
				{ name = "DiagnosticSignHint", text = icons.diagnostics.Hint },
				{ name = "DiagnosticSignInfo", text = icons.diagnostics.Information },
			},
		},
		virtual_text = false,
		update_in_insert = false,
		underline = true,
		severity_sort = true,
		float = {
			focusable = true,
			style = "minimal",
			border = "rounded",
			source = "always",
			header = "",
			prefix = "",
		},
	}

	vim.diagnostic.config(default_diagnostic_config)

	for _, sign in ipairs(vim.tbl_get(vim.diagnostic.config(), "signs", "values") or {}) do
		vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
	end

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
	require("lspconfig.ui.windows").default_options.border = "rounded"

	for _, server in pairs(servers) do
		local opts = {
			on_attach = M.on_attach,
			capabilities = M.common_capabilities(),
		}

		local require_ok, settings = pcall(require, "user.lspsettings." .. server)
		if require_ok then
			opts = vim.tbl_deep_extend("force", settings, opts)
		end

		local lcfg = local_lsp_cfg(server)
		if lcfg ~= nil then
			opts = vim.tbl_deep_extend("force", lcfg, opts)
		end

		if server == "lua_ls" then
			require("neodev").setup {}
		end

		lspconfig[server].setup(opts)
	end
end

return M
