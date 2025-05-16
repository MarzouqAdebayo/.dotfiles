return {
  {
    "hrsh7th/cmp-nvim-lsp"
  },
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
  },
  {
    "hrsh7th/nvim-cmp",
    config = function()
      vim.o.completeopt = 'menuone,noselect'
      local cmp = require("cmp")
      local cmpSetupTable = require("plugins.config.cmpconfig")
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup(cmpSetupTable)
    end,
  },
}
