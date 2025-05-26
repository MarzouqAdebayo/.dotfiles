return {
  'stevearc/oil.nvim',
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function ()
    local oil = require('oil')
    oil.setup({
      columns = {
        "icon",
        -- "permissions",
        -- "size",
        -- "mtime"
      },
      float = {
        max_height = 0.7,
        max_width = 0.7,
      },
    })
  end
}
