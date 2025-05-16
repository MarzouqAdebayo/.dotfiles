local wk = require "which-key"

-- Use LspAttach autocommand to only map the following keys
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

		wk.add {
			-- 	{ "g", group = "lsp" },
			-- 	{ "gd", vim.lsp.buf.definition, desc = "Goto Definition", mode = "n", buffer = ev.buf },
			-- 	{ "gD", vim.lsp.buf.declaration, desc = "Goto Declaration", mode = "n", buffer = ev.buf },
			-- 	{ "gr", vim.lsp.buf.references, desc = "References", mode = "n", buffer = ev.buf },
			-- 	{ "gI", vim.lsp.buf.implementation, desc = "Goto Implementation", mode = "n", buffer = ev.buf },
			-- 	{ "gy", vim.lsp.buf.type_definition, desc = "Goto T[y]pe Definition", mode = "n", buffer = ev.buf },
			-- 	{ "<C-k>", vim.lsp.buf.signature_help, desc = "Signature Help", mode = "n", buffer = ev.buf },
			{ "K", vim.lsp.buf.hover, desc = "Hover Documentation", mode = "n", buffer = ev.buf },
			{ "<leader>ra", vim.lsp.buf.rename, desc = "Rename All References", mode = "n", buffer = ev.buf },
			{ "<leader>ca", vim.lsp.buf.code_action, desc = "Code Actions", mode = { "n", "v" }, buffer = ev.buf },
			--
			-- 	-- { "<space>wa", vim.lsp.buf.add_workspace_folder, desc = "Remove Workspace Folder", mode = "n", buffer = ev.buf },
			-- 	-- { "<space>wr", vim.lsp.buf.remove_workspace_folder, desc = "List Workspace Folder", mode = "n", buffer = ev.buf },
			-- 	-- {
			-- 	-- 	"<space>wl",
			-- 	-- 	function()
			-- 	-- 		print(vim.inspect(vim.lsp.buf.list_workspace_folders))
			-- 	-- 	end,
			-- 	-- 	desc = "",
			-- 	-- 	mode = "n",
			-- 	-- 	buffer = ev.buf,
			-- 	-- },
		}
	end,
})

local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities.textDocument.completion.completionItem = {
	documentationFormat = { "markdown", "plaintext" },
	snippetSupport = true,
	preselectSupport = true,
	insertReplaceSupport = true,
	labelDetailsSupport = true,
	deprecatedSupport = true,
	commitCharactersSupport = true,
	tagSupport = { valueSet = { 1 } },
	resolveSupport = {
		properties = {
			"documentation",
			"detail",
			"additionalTextEdits",
		},
	},
}
-- Setup language servers.
local lspconfig = require "lspconfig"

-- setup multiple servers with same default options
local servers = {
	"html",
	"cssls",
	"lua_ls",
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
}

for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup {
		capabilities = capabilities,
	}
end

lspconfig.lua_ls.setup {
	capabilities = capabilities,
	settings = {
		Lua = {
			diagnostics = { globals = { "vim" } },
		},
	},
}

lspconfig.ts_ls.setup {
	capabilities = capabilities,
	on_attach = function(client, bufnr)
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
		client.server_capabilities.documentFormattingProvider = false -- Disable formatting
		client.server_capabilities.documentRangeFormattingProvider = false
	end,
	settings = {
		implicitProjectConfiguration = {
			checkJs = true,
		},
	},
}

lspconfig.eslint.setup {
	capabilities = capabilities,
	on_attach = function(client)
		client.server_capabilities.documentFormattingProvider = false -- Disable formatting
		client.server_capabilities.documentRangeFormattingProvider = false
	end,
}

lspconfig.svelte.setup {
	capabilities = capabilities,
	filetypes = { "svelte" },
	on_attach = function(client, bufnr)
		if client.name == "svelte" then
			vim.api.nvim_create_autocmd("BufWritePost", {
				pattern = { "*.js", "*.ts", "*.svelte" },
				callback = function(ctx)
					client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.file })
				end,
			})
		end
		if vim.bo[bufnr].filetype == "svelte" then
			vim.api.nvim_create_autocmd("BufWritePost", {
				pattern = { "*.js", "*.ts", "*.svelte" },
				callback = function(ctx)
					client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.file })
				end,
			})
		end
	end,
}

lspconfig.rust_analyzer.setup {
	capabilities = capabilities,
	on_attach = function(_, bufnr)
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	end,
	settings = {
		["rust-analyzer"] = {
			check = {
				command = "clippy", -- Use "clippy" for better linting, or "check"
			},
			diagnostics = {
				enable = true,
				experimental = {
					enable = true,
					enableNativeDiagnostics = true, -- Native diagnostics (improves real-time updates)
				},
			},
		},
	},
}
