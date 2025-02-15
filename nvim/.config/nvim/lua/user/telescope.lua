local M = {
	"nvim-telescope/telescope.nvim",
	event = "VimEnter",
	dependencies = {
		'nvim-lua/plenary.nvim',
		{
			'nvim-telescope/telescope-fzf-native.nvim',
			build = 'make',
			cond = function()
				return vim.fn.executable 'make' == 1
			end,
			},
			'nvim-telescope/telescope-ui-select.nvim',
			'nvim-tree/nvim-web-devicons',
			{
				"nvim-telescope/telescope-frecency.nvim",
				dependencies = { "kkharji/sqlite.lua" }
			}
	},
}

function M.config()
	local icons = require"user.icons"
	local actions = require "telescope.actions"

	require("telescope").setup {
		defaults = {
			prompt_prefix = icons.ui.Telescope .. " ",
			selection_caret = icons.ui.Forward .. " ",
			entry_prefix = "   ",
			initial_mode = "insert",
			selection_strategy = "reset",
			color_devicons = true,
			vimgrep_arguments = {
				"rg",
				"--color=never",
				"--no-heading",
				"--with-filename",
				"--line-number",
				"--column",
				"--smart-case",
				"--hidden",
				"--glob=!.git/",
			},
			file_ignore_patterns = {
				"^.git/",
				"^node_modules/"
			},
			mappings = {
				i = {
					-- Map <C-l> to send results to the location list
					["<C-l>"] = function(prompt_bufnr)
					actions.send_to_loclist(prompt_bufnr)
					actions.open_loclist(prompt_bufnr)  -- Optional: Open the location list after sending
					end,
				},
			},
		},
		pickers = {
			find_files = {
				hidden = true,
			},

			buffers = {
				mappings = {
					i = {
						["<C-d>"] = actions.delete_buffer,
					},
					n = {
						["dd"] = actions.delete_buffer,
					},
				},
			},
		},
		extensions = {
			fzf = {
				fuzzy = true, -- false will only do exact matching
				override_generic_sorter = true, -- override the generic sorter
				override_file_sorter = true, -- override the file sorter
				case_mode = "smart_case", -- or "ignore_case" or "respect_case"
			},
		  ['ui-select'] = {
				require('telescope.themes').get_dropdown(),
          },
		},
	}

	-- Enable Telescope extensions if they are installed
	pcall(require('telescope').load_extension, 'fzf')
	pcall(require('telescope').load_extension, 'ui-select')
	pcall(require('telescope').load_extension, 'frecency')

	-- See `:help telescope.builtin`
	local builtin = require 'telescope.builtin'
	vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
	vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
	vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
	vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
	vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
	vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
	vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
	vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })

	vim.keymap.set('n', '<leader>s.', function()
		require('telescope').extensions.frecency.frecency({ workspace = 'CWD' })
	end, { desc = '[S]earch Recent (. for repeated)' })

	vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

	vim.keymap.set('n', '<leader>/', function()
		builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
		  winblend = 10,
		  previewer = false,
		})
	end, { desc = '[/] Fuzzily search in current buffer' })

	vim.keymap.set('n', '<leader>s/', function()
		builtin.live_grep {
		  grep_open_files = true,
		  prompt_title = 'Live Grep in Open Files',
		}
	end, { desc = '[S]earch [/] in Open Files' })

	vim.keymap.set('n', '<leader>sn', function()
		builtin.find_files { cwd = vim.fn.stdpath 'config' }
	end, { desc = '[S]earch [N]eovim files' })
end

return M
