local icons = require 'icons'

-- Diffs for git revisions.
return {
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
    keys = {
      { "<leader>Gd", "<cmd>DiffviewOpen<cr>",          desc = "Open Diffview" },
      { "<leader>Gf", "<cmd>DiffviewFileHistory %<cr>", desc = "File History" },
      { "<leader>Gc", "<cmd>DiffviewClose<cr>",         desc = "Close Diffview" },
    },
    opts = function()
      local actions = require 'diffview.actions'

      require('diffview.ui.panel').Panel.default_config_float.border = 'rounded'

      return {
        default_args = { DiffviewFileHistory = { '%' } },
        diff_binaries = false,   -- Skip binary files
        enhanced_diff_hl = true, -- Better diff highlights
        use_icons = true,        -- Use Nerd Font icons
        view = {
          default = {
            layout = "diff2_horizontal", -- Side-by-side diff
            winbar_info = true,          -- Show file info
          },
          merge_tool = {
            layout = "diff3_mixed",     -- 3-way diff for conflicts
            disable_diagnostics = true, -- Avoid LSP clutter
          },
        },
        file_panel = {
          listing_style = "tree",                         -- Simple list for minimalism
          win_config = { position = "left", width = 30 }, -- Compact left panel
        },
        icons = {
          folder_closed = icons.symbol_kinds.Folder or "󰉋",
          folder_open = "󰝰",
        },
        signs = {
          fold_closed = icons.arrows.right or "▶",
          fold_open = icons.arrows.down or "▼",
          done = '',
        },
        keymaps = {
          disable_defaults = true, -- Use only our keymaps
          view = {
            -- Navigation
            { 'n', '<tab>',      actions.select_next_entry,             { desc = 'Open the diff for the next file' } },
            { 'n', '<s-tab>',    actions.select_prev_entry,             { desc = 'Open the diff for the previous file' } },
            { 'n', '[f',         actions.select_first_entry,            { desc = 'Open the diff for the first file' } },
            { 'n', ']f',         actions.select_last_entry,             { desc = 'Open the diff for the last file' } },
            { 'n', '[c',         actions.prev_conflict,                 { desc = 'Merge-tool: jump to the previous conflict' } },
            { 'n', ']c',         actions.next_conflict,                 { desc = 'Merge-tool: jump to the next conflict' } },
            { 'n', 'E',          actions.focus_files,                   { desc = 'Focus file tree' } },
            -- Conflict resolution (individual)
            { 'n', '<leader>Go', actions.conflict_choose('ours'),       { desc = 'Choose the OURS version of a conflict' } },
            { 'n', '<leader>Gt', actions.conflict_choose('theirs'),     { desc = 'Choose the THEIRS version of a conflict' } },
            { 'n', '<leader>Gb', actions.conflict_choose('base'),       { desc = 'Choose the BASE version of a conflict' } },
            { 'n', '<leader>Ga', actions.conflict_choose('all'),        { desc = 'Choose all the versions of a conflict' } },
            { 'n', '<leader>Gd', actions.conflict_choose('none'),       { desc = 'Delete the conflict region' } },
            -- Conflict resolution (file-wide)
            { 'n', '<leader>GO', actions.conflict_choose_all('ours'),   { desc = 'Choose the OURS version of a conflict for the whole file' } },
            { 'n', '<leader>GT', actions.conflict_choose_all('theirs'), { desc = 'Choose the THEIRS version of a conflict for the whole file' } },
            { 'n', '<leader>GB', actions.conflict_choose_all('base'),   { desc = 'Choose the BASE version of a conflict for the whole file' } },
          },
          diff2 = { { 'n', '?', actions.help { 'view', 'diff2' }, { desc = 'Open the help panel' } } },
          diff3 = { { 'n', '?', actions.help { 'view', 'diff3' }, { desc = 'Open the help panel' } } },
          file_panel = {
            -- Navigation
            { 'n', 'j',          actions.next_entry,                    { desc = 'Bring the cursor to the next file entry' } },
            { 'n', 'k',          actions.prev_entry,                    { desc = 'Bring the cursor to the previous file entry' } },
            { 'n', '<cr>',       actions.select_entry,                  { desc = 'Open the diff for the selected entry' } },
            { 'n', 'E',          actions.focus_entry,                   { desc = 'Focus the view for the selected entry' } },
            -- Staging
            { 'n', 's',          actions.toggle_stage_entry,            { desc = 'Stage / unstage the selected entry' } },
            { 'n', 'S',          actions.stage_all,                     { desc = 'Stage all entries' } },
            { 'n', 'U',          actions.unstage_all,                   { desc = 'Unstage all entries' } },
            { 'n', 'X',          actions.restore_entry,                 { desc = 'Restore entry to the state on the left side' } },
            { 'n', 'L',          actions.open_commit_log,               { desc = 'Open the commit log panel' } }, -- Conflict resolution (file-wide)
            { 'n', 'gf',         actions.goto_file_tab,                 { desc = 'Open the file in a new tabpage' } },
            -- Folds
            { 'n', 'za',         actions.toggle_fold,                   { desc = 'Toggle fold' } },
            { 'n', 'zR',         actions.open_all_folds,                { desc = 'Expand all folds' } },
            { 'n', 'zM',         actions.close_all_folds,               { desc = 'Collapse all folds' } },
            -- Scroll
            { 'n', '<c-b>',      actions.scroll_view(-0.25),            { desc = 'Scroll the view up' } },
            { 'n', '<c-f>',      actions.scroll_view(0.25),             { desc = 'Scroll the view down' } },
            -- Selection
            { 'n', '<tab>',      actions.select_next_entry,             { desc = 'Open the diff for the next file' } },
            { 'n', '<s-tab>',    actions.select_prev_entry,             { desc = 'Open the diff for the previous file' } },
            { 'n', '[f',         actions.select_first_entry,            { desc = 'Open the diff for the first file' } },
            { 'n', ']f',         actions.select_last_entry,             { desc = 'Open the diff for the last file' } },
            { 'n', 'i',          actions.listing_style,                 { desc = 'Toggle between "list" and "tree" views' } },
            { 'n', '[c',         actions.prev_conflict,                 { desc = 'Go to the previous conflict' } },
            { 'n', ']c',         actions.next_conflict,                 { desc = 'Go to the next conflict' } },
            { 'n', '?',          actions.help('file_panel'),            { desc = 'Open the help panel' } },
            { 'n', '<leader>GO', actions.conflict_choose_all('ours'),   { desc = 'Choose the OURS version of a conflict for the whole file' } },
            { 'n', '<leader>GT', actions.conflict_choose_all('theirs'), { desc = 'Choose the THEIRS version of a conflict for the whole file' } },
            { 'n', '<leader>GB', actions.conflict_choose_all('base'),   { desc = 'Choose the BASE version of a conflict for the whole file' } },
            { 'n', '<leader>GA', actions.conflict_choose_all('all'),    { desc = 'Choose all the versions of a conflict for the whole file' } },
            { 'n', '<leader>GD', actions.conflict_choose_all('none'),   { desc = 'Delete the conflict region for the whole file' } },
          },
        },
        file_history_panel = {
          { 'n', '!',       actions.options,                    { desc = 'Open the option panel' } },
          { 'n', 'o',       actions.open_in_diffview,           { desc = 'Open the entry under the cursor in a diffview' } },
          { 'n', 'y',       actions.copy_hash,                  { desc = 'Copy the commit hash of the entry under the cursor' } },
          { 'n', 'L',       actions.open_commit_log,            { desc = 'Show commit details' } },
          { 'n', 'X',       actions.restore_entry,              { desc = 'Restore file to the state from the selected entry' } },
          { 'n', 'za',      actions.toggle_fold,                { desc = 'Toggle fold' } },
          { 'n', 'zR',      actions.open_all_folds,             { desc = 'Expand all folds' } },
          { 'n', 'zM',      actions.close_all_folds,            { desc = 'Collapse all folds' } },
          { 'n', 'j',       actions.next_entry,                 { desc = 'Bring the cursor to the next file entry' } },
          { 'n', 'k',       actions.prev_entry,                 { desc = 'Bring the cursor to the previous file entry' } },
          { 'n', '<cr>',    actions.select_entry,               { desc = 'Open the diff for the selected entry' } },
          { 'n', 'E',       actions.focus_entry,                { desc = 'Focus the view for the selected entry' } },
          { 'n', '<c-b>',   actions.scroll_view(-0.25),         { desc = 'Scroll the view up' } },
          { 'n', '<c-f>',   actions.scroll_view(0.25),          { desc = 'Scroll the view down' } },
          { 'n', '<tab>',   actions.select_next_entry,          { desc = 'Open the diff for the next file' } },
          { 'n', '<s-tab>', actions.select_prev_entry,          { desc = 'Open the diff for the previous file' } },
          { 'n', '[f',      actions.select_first_entry,         { desc = 'Open the diff for the first file' } },
          { 'n', ']f',      actions.select_last_entry,          { desc = 'Open the diff for the last file' } },
          { 'n', 'gf',      actions.goto_file_tab,              { desc = 'Open the file in a new tabpage' } },
          { 'n', '?',       actions.help('file_history_panel'), { desc = 'Open the help panel' } },
        },
        option_panel = {
          { 'n', '<tab>', actions.select_entry,         { desc = 'Change the current option' } },
          { 'n', 'q',     actions.close,                { desc = 'Close the panel' } },
          { 'n', '?',     actions.help('option_panel'), { desc = 'Open the help panel' } },
        },
        help_panel = {
          { 'n', 'q', actions.close, { desc = 'Close help menu' } },
        },
      }
    end,
  },
}
