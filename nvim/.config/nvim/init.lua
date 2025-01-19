-- Core stuff
require "user.launch"
require "user.options"
require "user.keymaps"

-- Lazy plugins
-- spec "user.colorscheme.gruvbox"
-- spec "user.colorscheme.solarized"
-- spec "user.colorscheme.solarizedosaka"
-- spec "user.colorscheme.oxocarbon"
spec "user.colorscheme.onedark"
spec "user.devicons"

spec "user.telescope"

spec "user.treesitter"
spec "user.schemastore"
spec "user.mason"
spec "user.lspconfig"
spec "user.cmp"
spec "user.none-ls"
spec "user.autopairs"
spec "user.go"

spec "user.gitsigns"
spec "user.diffview"

spec "user.lsp-progress"
spec "user.lualine"

spec "user.alpha"
spec "user.indentline"

spec "user.nvimtree"

-- Load Lazy
require "user.lazy"
