local opts = require "plugins.config.snacks.options"
local keymaps = require "plugins.config.snacks.keymaps"
local autocmds = require "plugins.config.snacks.autocmds"

local snacks = {
  "folke/snacks.nvim",
  priority = 1200,
  lazy = false, -- ensure it loads at startup
  opts = opts,
  keys = keymaps,
  init = autocmds,
}

return snacks
