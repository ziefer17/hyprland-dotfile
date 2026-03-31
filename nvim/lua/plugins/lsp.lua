-- lua/plugins/lsp.lua
return {
  "neovim/nvim-lspconfig",
  opts = {
    capabilities = {
      workspace = {
        didChangeWatchedFiles = {
          dynamicRegistration = true,
        },
      },
    },
  },
  {
    "Hoffs/omnisharp-extended-lsp.nvim",
    ft = { "cs" }, -- load when you open a .cs file
  },
}
