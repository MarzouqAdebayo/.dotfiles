local wk = require "which-key"

-- Use LspAttach autocommand to only map the following keys
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
  callback = function(event)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[event.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

    local map = function(keys, func, desc, mode)
      mode = mode or "n"
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
    end

    wk.add {
      { "g",          group = "lsp" },
      -- 	{ "gd", vim.lsp.buf.definition, desc = "Goto Definition", mode = "n", buffer = ev.buf },
      -- 	{ "gD", vim.lsp.buf.declaration, desc = "Goto Declaration", mode = "n", buffer = ev.buf },
      -- 	{ "gr", vim.lsp.buf.references, desc = "References", mode = "n", buffer = ev.buf },
      -- 	{ "gI", vim.lsp.buf.implementation, desc = "Goto Implementation", mode = "n", buffer = ev.buf },
      -- 	{ "gy", vim.lsp.buf.type_definition, desc = "Goto T[y]pe Definition", mode = "n", buffer = ev.buf },
      -- 	{ "<C-k>", vim.lsp.buf.signature_help, desc = "Signature Help", mode = "n", buffer = ev.buf },
      -- { "K", vim.lsp.buf.hover, desc = "Hover Documentation", mode = "n", buffer = ev.buf },
      { "<leader>ra", vim.lsp.buf.rename,      desc = "Rename All References", mode = "n",          buffer = event.buf },
      { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Actions",          mode = { "n", "v" }, buffer = event.buf },
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

    -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
    ---@param client vim.lsp.Client
    ---@param method vim.lsp.protocol.Method
    ---@param bufnr? integer some lsp support methods only in specific files
    ---@return boolean
    local function client_supports_method(client, method, bufnr)
      if vim.fn.has "nvim-0.11" == 1 then
        return client:supports_method(method, bufnr)
      else
        return client.supports_method(method, { bufnr = bufnr })
      end
    end

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if
        client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf)
    then
      local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd("LspDetach", {
        group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = "kickstart-lsp-highlight", buffer = event2.buf }
        end,
      })
    end

    -- The following code creates a keymap to toggle inlay hints in your
    -- code, if the language server you are using supports them
    --
    -- This may be unwanted, since they displace some of your code
    if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
      map("<leader>th", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
      end, "[T]oggle Inlay [H]ints")
    end
  end,
})

local capabilities = {
  textDocument = {
    completion = {
      completionItem = {
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
    }
  }
}
require("blink.cmp").get_lsp_capabilities(capabilities)

-- setup multiple servers with same default options
local servers = {
  html = {},
  cssls = {},
  lua_ls = {
    settings = {
      Lua = {
        completion = {
          callSnippet = "Replace",
        },
        diagnostics = { globals = { "vim" }, disable = { "missing-fields" } },
      },
    },
  },
  ts_ls = {
    on_attach = function(client, bufnr)
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      client.server_capabilities.documentFormattingProvider = false -- Disable formatting
      client.server_capabilities.documentRangeFormattingProvider = false
    end,
    settings = {
      -- typescript = {
      -- 	diagnosticOption = {
      -- 		enable = true,
      -- 		onlyOpenFiles = true,
      -- 	},
      -- },
      implicitProjectConfiguration = {
        checkJs = true,
      },
    },
  },
  svelte = {
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
  },
  tailwindcss = {},
  eslint = {
    on_attach = function(client)
      client.server_capabilities.documentFormattingProvider = false -- Disable formatting
      client.server_capabilities.documentRangeFormattingProvider = false
    end,
  },
  sqlls = {},
  gopls = {},
  pylsp = {},
  bashls = {},
  prismals = {},
  dockerls = {},
  docker_compose_language_service = {},
  rust_analyzer = {
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
  },
}

local ensure_installed = vim.tbl_keys(servers or {})
require("mason-tool-installer").setup { ensure_installed = ensure_installed }

require("mason-lspconfig").setup {
  ensure_installed = {},
  automatic_installation = false,
  handlers = {
    function(server_name)
      local server = servers[server_name] or {}

      server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
      require("lspconfig")[server_name].setup(server)
    end,
  },
}

return {}
