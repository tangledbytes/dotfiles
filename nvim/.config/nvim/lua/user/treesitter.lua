local M = {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    opts = {
      ensure_installed = { 'bash', 'c', 'html', 'lua', 'luadoc', 'markdown', 'vim', 'vimdoc', 'rust', 'go', 'javascript' },
      auto_install = true,
      highlight = {
        enable = true,
        -- Ruby doesn't like treesitter, add others if they don't like treesitter either
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
}

function M.config(_, opts)
	require('nvim-treesitter.configs').setup(opts)
end

-- TODO: Add textobject things

return M
