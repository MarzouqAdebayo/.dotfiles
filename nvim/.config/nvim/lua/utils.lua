local function setup_lsp_folding()
  local bufnr = vim.api.nvim_get_current_buf()

  -- Check if LSP folding is available
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  local has_folding_capability = false

  for _, client in ipairs(clients) do
    if client:supports_method('textDocument/foldingRange') then
      has_folding_capability = true
      break
    end
  end

  if has_folding_capability and false then
    -- Use LSP folding
    vim.api.nvim_buf_call(bufnr, function()
      vim.wo[0][0].foldmethod = 'expr'
      vim.wo[0][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
      vim.wo[0][0].foldlevel = 99
      -- vim.wo[0][0].foldlevelstart = 99
      -- Refresh fold display
      vim.cmd.normal('zM')
      vim.cmd.normal('zx')
      vim.notify("LSP folding enabled", vim.log.levels.INFO, {
        timeout = 3000, animate = false
      })
    end)
  end

  return has_folding_capability
end

local function setup_treesitter_folding()
  local bufnr = vim.api.nvim_get_current_buf()

  if vim.bo.filetype ~= 'bigfile' and pcall(vim.treesitter.start, bufnr) then
    vim.api.nvim_buf_call(bufnr, function()
      vim.wo[0][0].foldmethod = 'expr'
      vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      vim.wo[0][0].foldlevel = 99
      -- vim.wo[0][0].foldlevelstart = 99
      -- Refresh fold display
      vim.cmd.normal('zM')
      vim.cmd.normal('zx')
      vim.notify("Tree-sitter folding enabled", vim.log.levels.INFO, {
        timeout = 3000, animate = false
      })
    end)
  else
    -- Final fallback to indent folding
    vim.api.nvim_buf_call(bufnr, function()
      vim.wo[0][0].foldmethod = 'indent'
      vim.wo[0][0].foldlevel = 99
      -- Refresh fold display
      vim.cmd.normal('zM')
      vim.cmd.normal('zx')
      -- vim.notify("Indent folding enabled", vim.log.levels.INFO, {
      --   timeout = 3000, animate = false
      -- })
    end)
  end
end

return {
  setup_treesitter_folding = setup_treesitter_folding,
  setup_lsp_folding = setup_lsp_folding
}
