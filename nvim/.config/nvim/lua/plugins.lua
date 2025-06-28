local plugins_paths = {
    -- Important
    "plugins.lsp",
    "plugins.blink-cmp",
    "plugins.nvim-treesitter",
    "plugins.oil",
    "plugins.snipe",
    "plugins.which-key",
    "plugins.snacks",
    "plugins.typescript-tools",

    "plugins.lsp-saga",

    -- UI
    "plugins.oldtale",
    "plugins.nvim-webdev-icons",
    "plugins.bufferline",
    "plugins.lualine",

    -- QOL 1
    "plugins.undotree",
    "plugins.nvim-bqf",
    "plugins.markdown-preview",
    "plugins.diffview",
    "plugins.gitsigns",
    "plugins.grug-far",
    -- "plugins.tdo",

    -- QOL 2
    "plugins.nvim-ts-autotag",
    "plugins.nvim-surround",
    "plugins.nvim-autopairs",
    "plugins.nvim-ts-context-commentstring",
    "plugins.flash",
    "plugins.treesj",
    "plugins.yanky",
    "plugins.virt-column",
    "plugins.transparent",
    "plugins.tiny-inline-diagnostic"
}

local plugins = {}

for _, plugin in ipairs(plugins_paths) do
    local ok, mod = pcall(require, plugin)
    if ok then
        table.insert(plugins, mod)
    else
        vim.notify("Failed to load plugin config: " .. plugin, vim.log.levels.WARN)
    end
end

return plugins
