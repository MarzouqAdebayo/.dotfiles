-- lua/plugins/snacks/autocmds.lua
local init = function()
  vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
      -- Setup some globals for debugging (lazy-loaded)
      ---@diagnostic disable-next-line: duplicate-set-field
      _G.dd = function(...)
        Snacks.debug.inspect(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      _G.bt = function()
        Snacks.debug.backtrace()
      end
      vim.print = _G.dd -- Override print to use Snacks

      -- Create some toggle mappings
      Snacks.toggle.option("spell", { name = "Spelling" }):map "<leader>sts"
      Snacks.toggle.option("wrap", { name = "Wrap" }):map "<leader>stw"
      Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map "<leader>stL"
      Snacks.toggle.diagnostics():map "<leader>std"
      Snacks.toggle.line_number():map "<leader>stl"
      Snacks.toggle
          .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
          :map "<leader>stc"
      Snacks.toggle.treesitter():map "<leader>stt"
      Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map "<leader>stb"
      Snacks.toggle.inlay_hints():map "<leader>sth"
      Snacks.toggle.indent():map "<leader>sti"
      Snacks.toggle.dim():map "<leader>stD"
    end,
  })
end

return init
