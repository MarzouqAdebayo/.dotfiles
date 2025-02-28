local opts = require "plugins.snacks-config.options"
local keymaps = require "plugins.snacks-config.keymaps"
local autocmds = require "plugins.snacks-config.autocmds"

local snacks = {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false, -- ensure it loads at startup
	opts = opts,
	keys = keymaps,
	init = autocmds,
}

return snacks
