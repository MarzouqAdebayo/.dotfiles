return {
  "nvimdev/lspsaga.nvim",
  event = "LspAttach",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require "plugins.config.sagaconfig"

    local colors = require "oldtale.palette"
    local normal_colors = { bg = colors.none }
    local border_colors = { bg = colors.none, fg = colors.orange }

    vim.api.nvim_set_hl(0, "SagaNormal", normal_colors)
    vim.api.nvim_set_hl(0, "SagaBorder", border_colors)

    vim.api.nvim_set_hl(0, "ActionPreviewNormal", normal_colors)
    vim.api.nvim_set_hl(0, "ActionPreviewBorder", border_colors)

    vim.api.nvim_set_hl(0, "DiagnosticNormal", normal_colors)
    vim.api.nvim_set_hl(0, "DiagnosticBorder", border_colors)
    vim.api.nvim_set_hl(0, "DiagnosticShowNormal", normal_colors)
    vim.api.nvim_set_hl(0, "DiagnosticShowBorder", border_colors)
  end,
}
