local diagnostic_icons = require('icons').diagnostics
local methods = vim.lsp.protocol.Methods

--- Sets up LSP keymaps and autocommands for the given buffer.
---@param client vim.lsp.Client
---@param bufnr integer
local function on_attach(client, bufnr)
  ---@param keys string
  ---@param func string|function
  ---@param desc string
  ---@param mode? string|string[]
  local function keymap(keys, func, desc, mode)
    mode = mode or "n"
    vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
  end

  -- Enable completion triggered by <c-x><c-o>
  vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
  -- Enable document highlighting from the given language client in the given buffer
  if vim.lsp.document_color ~= nil then
    vim.lsp.document_color.enable(true, bufnr)
  end

  if client and client:supports_method(methods.textDocument_documentHighlight) then
    local highlight_augroup = vim.api.nvim_create_augroup("user-lsp-highlight", { clear = false })
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI", "InsertLeave" }, {
      group = highlight_augroup,
      desc = "Highlight references under cursor",
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })

    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "InsertEnter", "BufLeave" }, {
      group = highlight_augroup,
      desc = "Clear highlight references",
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })

    vim.api.nvim_create_autocmd("LspDetach", {
      group = vim.api.nvim_create_augroup("user-lsp-detach", { clear = true }),
      callback = function(event2)
        vim.lsp.buf.clear_references()
        vim.api.nvim_clear_autocmds { group = "user-lsp-highlight", buffer = event2.buf }
      end,
    })
  end

  if client and client:supports_method(methods.textDocument_inlayHint) then
    local inlay_hints_group = vim.api.nvim_create_augroup('user-toggle-inlay-hints', { clear = false })

    if vim.g.inlay_hints then
      -- Initial inlay hint display.
      -- Idk why but without the delay inlay hints aren't displayed at the very start.
      vim.defer_fn(function()
        local mode = vim.api.nvim_get_mode().mode
        vim.lsp.inlay_hint.enable(mode == 'n' or mode == 'v', { bufnr = bufnr })
      end, 500)
    end

    vim.api.nvim_create_autocmd('InsertEnter', {
      group = inlay_hints_group,
      desc = 'Enable inlay hints',
      buffer = bufnr,
      callback = function()
        if vim.g.inlay_hints then
          vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
        end
      end,
    })

    vim.api.nvim_create_autocmd('InsertLeave', {
      group = inlay_hints_group,
      desc = 'Disable inlay hints',
      buffer = bufnr,
      callback = function()
        if vim.g.inlay_hints then
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end
      end,
    })

    keymap("<leader>th", function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = bufnr })
    end, "[T]oggle Inlay [H]ints")
  end

  -- Add "Fix all" command for ESLint.
  if client.name == 'eslint' then
    keymap('<leader>ce', function()
      if not client then
        return
      end

      client:request(methods.workspace_executeCommand, {
        command = 'eslint.applyAllFixes',
        arguments = {
          {
            uri = vim.uri_from_bufnr(bufnr),
            version = vim.lsp.util.buf_versions[bufnr],
          },
        },
      }, nil, bufnr)
    end, 'Fix all ESLint errors', "n")
  end
end

-- Diagnostics {{{
-- `:h vim.diagnostic`
-- https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization#customizing-how-diagnostics-are-displayed
vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})
-- }}}

-- Define the diagnostic signs.
for severity, icon in pairs(diagnostic_icons) do
  local hl = 'DiagnosticSign' .. severity:sub(1, 1) .. severity:sub(2):lower()
  vim.fn.sign_define(hl, {
    numhl = hl,
    -- text = icon,
    -- texthl = hl
  })
end

-- Diagnostic configuration.
vim.diagnostic.config {
  virtual_text = {
    prefix = '',
    spacing = 2,
    format = function(diagnostic)
      -- Use shorter, nicer names for some sources:
      local special_sources = {
        ['Lua Diagnostics.'] = 'lua',
        ['Lua Syntax Check.'] = 'lua',
      }

      local message = diagnostic_icons[vim.diagnostic.severity[diagnostic.severity]]
      if diagnostic.source then
        message = string.format('%s %s', message, special_sources[diagnostic.source] or diagnostic.source)
      end
      if diagnostic.code then
        message = string.format('%s[%s]', message, diagnostic.code)
      end

      return message .. ' '
    end,
  },
  float = {
    source = 'if_many',
    -- Show severity icons as prefixes.
    prefix = function(diag)
      local level = vim.diagnostic.severity[diag.severity]
      local prefix = string.format(' %s ', diagnostic_icons[level])
      return prefix, 'Diagnostic' .. level:gsub('^%l', string.upper)
    end,
  },
  -- Disable signs in the gutter.
  signs = false,
}

-- Override the virtual text diagnostic handler so that the most severe diagnostic is shown first.
local show_handler = vim.diagnostic.handlers.virtual_text.show
assert(show_handler)
local hide_handler = vim.diagnostic.handlers.virtual_text.hide
vim.diagnostic.handlers.virtual_text = {
  show = function(ns, bufnr, diagnostics, opts)
    table.sort(diagnostics, function(diag1, diag2)
      return diag1.severity > diag2.severity
    end)
    return show_handler(ns, bufnr, diagnostics, opts)
  end,
  hide = hide_handler,
}

-- Update mappings when registering dynamic capabilities.
local register_capability = vim.lsp.handlers[methods.client_registerCapability]
vim.lsp.handlers[methods.client_registerCapability] = function(err, res, ctx)
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  if not client then
    return
  end

  on_attach(client, vim.api.nvim_get_current_buf())

  return register_capability(err, res, ctx)
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
  desc = 'Configure LSP settings and keymaps',
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)

    -- I don't think this can happen but it's a wild world out there.
    if not client then
      return
    end

    on_attach(client, event.buf)
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
    },
    foldingRange = {
      dynamicRegistration = false,
      rangeLimit = 5000,
      lineFoldingOnly = true,
      foldingRangeKind = {
        valueSet = {
          "imports",
          "region"
        }
      },
      foldingRange = {
        collapsedText = false
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
  vtsls = {
    on_attach = function(client, bufnr)
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      client.server_capabilities.documentFormattingProvider = false -- Disable formatting
      client.server_capabilities.documentRangeFormattingProvider = false

      -- require("typescript-tools").setup({
      --     -- Options for typescript-tools.nvim go here
      --     -- For example:
      --     parent_org_imports = {
      --         "source.organizeImports",
      --         "source.removeUnusedImports",
      --     },
      --     enable_extended_diagnostics = true, -- Enable diagnostics like `_typescript.tsserver.diagnostics.ignored`
      --     enable_import_action_on_complete = true,
      --     enable_rename_after_code_action = true,
      --     -- Replace this if you want to use a specific LSP server for code actions/rename
      --     server = "vtsls",
      -- })
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
      typescript = {
        tsserver = {
          -- For very large projects, consider increasing memory
          -- maxTsServerMemory = 16184
        }
      },
      -- Enable move to file code action (requires client-side handling, but vtsls exposes it)
      enableMoveToFileCodeAction = true,
      -- Set to true to automatically use workspace tsdk if available
      autoUseWorkspaceTsdk = true,
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
      -- disable formatting capability
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end,
  },
  sqlls = {},
  gopls = {},
  pylsp = {},
  bashls = {},
  prismals = {
    on_attach = function(client)
      -- disable formatting capability
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end
  },
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

local lspconfig = require("lspconfig")
require("mason-lspconfig").setup {
  ensure_installed = {},
  automatic_installation = false,
  handlers = {
    function(server_name)
      local server = servers[server_name] or {}

      server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
      lspconfig[server_name].setup(server)
    end,
  },
}

return {}
