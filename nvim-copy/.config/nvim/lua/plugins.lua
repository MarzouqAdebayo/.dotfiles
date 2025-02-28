local plugin_files = {
	"plugins.snacks",
	"plugins.oil",
	"plugins.lsp-config",
	"plugins.bufferline",
	-- Buggy - Causes flickering and redraws
	-- "plugins.comfy-line-numbers",
	-- Buggy
	"plugins.completions",
	"plugins.conform",
	"plugins.debugging",
	"plugins.flash",
	"plugins.hardtime",
	"plugins.harpoon",
	"plugins.illuminate",
	"plugins.leetcode",
	"plugins.lualine",
	"plugins.nvim-autopairs",
	"plugins.nvim-surround",
	"plugins.nvim-ts-autotag",
	"plugins.oil",
	"plugins.markview",
	"plugins.rosepine",
	"plugins.tdo",
	"plugins.todo-comments",
	"plugins.treesitter",
	"plugins.undotree",
	"plugins.which-key",
	"plugins.oldworld",
	"plugins.nvim-ts-context-commentstring",
	"plugins.nvim-treesitter-context",
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
