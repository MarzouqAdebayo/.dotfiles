return {
  {
    "lukas-reineke/virt-column.nvim",
    event = { "BufReadPost", "BufNewFile" }, -- Lazy-load on buffer creation
    config = function()
      require("virt-column").setup({
        virtcolumn = "+1,80", -- Column at +1 (textwidth+1) and 80
        exclude = {
          buftypes = {
            "nofile",   -- Common for floating windows, scratch buffers
            "terminal", -- Terminal buffers
            "quickfix", -- Quickfix lists
            "prompt",   -- Command-line prompts
            "popup",    -- Popup windows
          },
          filetypes = {
            "dashboard", -- Common dashboard plugin filetype
            "NvimTree",  -- File explorer
            "neo-tree",  -- Another file explorer
            "startify",  -- Another dashboard
            "Trouble",   -- Diagnostics list
            "qf",        -- Quickfix window
            "diff",      -- Diffview.nvim or other diff buffers
          },
        },
      })
    end,
  },
}
