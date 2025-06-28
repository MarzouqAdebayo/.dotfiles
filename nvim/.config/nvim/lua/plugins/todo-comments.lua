local opts = {
  keywords = {
    -- Task-related
    TODO = { icon = " ", color = "info", alt = { "todo", "task", "✔" } },
    FIX = { icon = " ", color = "error", alt = { "fix", "bug", "🐛", "fixme", "hotfix", "patch" } },
    BUG = { icon = " ", color = "error", alt = { "bug", "🐞", "error", "issue" } },
    FIXME = { icon = " ", color = "error", alt = { "fixme", "debug", "defect", "⚠" } },

    -- Workarounds & Hacks
    HACK = { icon = " ", color = "warning", alt = { "hack", "workaround", "kludge", "temp", "🚧" } },
    OPTIMIZE = { icon = " ", color = "hint", alt = { "optimize", "performance", "speedup", "perf", "⚡" } },

    -- Documentation & Notes
    NOTE = { icon = " ", color = "hint", alt = { "note", "info", "ℹ", "hint", "remember" } },
    XXX = { icon = " ", color = "warning", alt = { "warning", "danger", "caution", "⚠" } },
    IDEA = { icon = "󰛨 ", color = "hint", alt = { "idea", "💡", "concept", "thought", "brainstorm" } },
    REVIEW = { icon = " ", color = "hint", alt = { "review", "check", "audit", "inspect", "verify" } },

    -- Future Work & Enhancements
    DEPRECATE = { icon = " ", color = "warning", alt = { "deprecate", "obsolete", "remove", "outdated" } },
    TEMP = { icon = "⚠ ", color = "warning", alt = { "temp", "temporary", "short-term", "remove-later" } },
    REFACTOR = {
      icon = "󱌢",
      color = "info",
      alt = { "refactor", "rework", "cleanup", "improve", "restructure" },
    },
    FEATURE = { icon = "✨", color = "info", alt = { "feature", "enhancement", "add", "new", "🚀" } },

    -- Debugging
    DEBUG = { icon = "", color = "warning", alt = { "debug", "trace", "log", "troubleshoot" } },
    LOG = { icon = "", color = "hint", alt = { "log", "logging", "trace", "record" } },

    -- Security
    SECURITY = { icon = "🔒", color = "error", alt = { "security", "vulnerability", "risk", "protect", "⚠" } },
    EXPLOIT = { icon = "", color = "error", alt = { "exploit", "danger", "attack", "vuln" } },
  },

}


return {
  "folke/todo-comments.nvim",
  -- optional = true,
  dependencies = { "nvim-lua/plenary.nvim" },
  event = "VeryLazy", -- Ensures it loads properly
  config = function()
    require("todo-comments").setup(opts)

    vim.keymap.set("n", "]t", function()
      require("todo-comments").jump_next()
    end, { desc = "Next todo comment" })

    vim.keymap.set("n", "[t", function()
      require("todo-comments").jump_prev()
    end, { desc = "Previous todo comment" })
  end,
}
