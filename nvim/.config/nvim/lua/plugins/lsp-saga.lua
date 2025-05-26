return {
  "nvimdev/lspsaga.nvim",
  event = "LspAttach",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require "plugins.config.lsp-saga-config"
  end,
}
