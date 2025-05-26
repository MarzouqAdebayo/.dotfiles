return {
  "leath-dub/snipe.nvim",
  config = function()
    local snipe = require "snipe"

    snipe.setup {
      ui = {
        position = "cursor",
        open_win_override = {
          border = "rounded",
        },
      },
      hints = {
        dictionary = "fcsghl;wertyuiopmnbv",
      },
      navigate = {
        cancel_snipe = "q",
        close_buffer = "x",
      },
    }
  end,
}
