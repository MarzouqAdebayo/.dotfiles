vim.g.projects_dir = vim.env.HOME .. '/Documents/Code'
vim.g.personal_projects_dir = vim.g.projects_dir .. '/personal'
vim.g.work_projects_dir = vim.g.projects_dir .. '/shaare'

-- Install lazy
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- General setup in proper order
require "settings"
require "commands"
require "autocmds"
require "marks"
local plugins = require "plugins"

-- Configure plugins.
require('lazy').setup(plugins, {
  ui = { border = 'rounded' },
  install = {
    -- missing = false,
  },
  change_detection = { notify = false },
  -- None of my plugins use luarocks so disable this.
  rocks = {
    enabled = false,
  },
  performance = {
    rtp = {
      -- Stuff I don't use.
      disabled_plugins = {
        'gzip',
        'netrwPlugin',
        'rplugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
})
require "utils"
require "keymaps"
require("highlights").init_highlights()
-- require "winbar"
