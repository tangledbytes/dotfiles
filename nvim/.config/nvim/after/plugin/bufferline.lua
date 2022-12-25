require("bufferline").setup({
    options = {
        diagnostics = 'nvim_lsp',
        mode = 'tabs',
        offsets = {{filetype = "NvimTree", text = "File Explorer", text_align = "center"}},
    }
})
