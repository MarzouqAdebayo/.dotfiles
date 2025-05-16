return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup {
				ensure_installed = {
					"lua_ls",
					"html",
					"cssls",
					"ts_ls",
					"svelte",
					"tailwindcss",
					"eslint",
					"sqlls",
					"gopls",
					"pylsp",
					"bashls",
					"prismals",
					"dockerls",
					"docker_compose_language_service",
					"rust_analyzer",
				},
			}
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			-- local capabilities = require('cmp_nvim_lsp').default_capabilities()
			require "plugins.config.lspconfig"
		end,
	},
}
