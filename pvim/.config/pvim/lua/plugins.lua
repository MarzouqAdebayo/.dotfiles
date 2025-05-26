local plugin_files = {
  "plugins.snacks",
  "plugins.oil",
  "plugins.lsp-config",
  "plugins.lsp-saga",
  -- "plugins.bufferline",
  -- "plugins.blink-cmp",
  "plugins.conform",
  -- "plugins.debugging",
  "plugins.flash",
  -- "plugins.hardtime",
  "plugins.snipe",
  -- "plugins.harpoon",
  "plugins.lualine",
  "plugins.nvim-autopairs",
  "plugins.nvim-surround",
  "plugins.nvim-ts-autotag",
  -- "plugins.markview",

  -- Colorshemes
  -- "plugins.transparent",
  "plugins.oldworld",
  "plugins.oldtale",
  "plugins.mellow",
  "plugins.rosepine",
  "plugins.kanagawa",
  "plugins.kanagawa-paper",
  "plugins.oh-lucy",
  "plugins.obscure",

  -- Utils
  "plugins.git-conflict",
  -- "plugins.gitsigns",
  "plugins.fidget",
  "plugins.nvim-highlight-colors",
  "plugins.tdo",
  "plugins.todo-comments",
  "plugins.treesitter",
  "plugins.undotree",
  "plugins.which-key",
  "plugins.nvim-ts-context-commentstring",
  -- "plugins.nvim-treesitter-context",
  "plugins.nvim-bqf",
  "plugins.tiny-inline-diagnostic",
  "plugins.nvim-ufo",
}

local plugins = {}

for _, plugin in ipairs(plugin_files) do
  local ok, mod = pcall(require, plugin)
  if ok then
    table.insert(plugins, mod)
  else
    vim.notify("Failed to load plugin config: " .. plugin, vim.log.levels.WARN)
  end
end

return plugins
