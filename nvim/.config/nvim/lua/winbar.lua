local folder_icon = require('icons').symbol_kinds.Folder

local M = {}

--- Window bar that shows the current file path (in a fancy way).
---@return string
function M.render()
  -- Get the path and expand variables.
  local path = vim.fs.normalize(vim.fn.expand '%:p' --[[@as string]])

  -- No special styling for diff views.
  if vim.startswith(path, 'diffview') then
    return string.format('%%#Winbar#%s', path)
  end

  -- Replace slashes by arrows.
  local separator = ' %#WinbarSeparator# '

  local prefix, prefix_path = '', ''

  -- If the window gets too narrow, shorten the path and drop the prefix.
  if vim.api.nvim_win_get_width(0) < math.floor(vim.o.columns / 3) then
    path = vim.fn.pathshorten(path)
  else
    -- For some special folders, add a prefix instead of the full path (making
    -- sure to pick the longest prefix).
    ---@type table<string, string>
    local special_dirs = {
      CODE = vim.g.projects_dir,
      -- DOTFILES = vim.env.XDG_CONFIG_HOME,
      -- GIT = vim.g.work_projects_dir,
      HOME = vim.env.HOME,
      PERSONAL = vim.g.personal_projects_dir,
      WORK = vim.g.work_projects_dir,
    }
    for dir_name, dir_path in pairs(special_dirs) do
      if vim.startswith(path, vim.fs.normalize(dir_path)) and #dir_path > #prefix_path then
        prefix, prefix_path = dir_name, dir_path
      end
    end
    if prefix ~= '' then
      path = path:gsub('^' .. prefix_path, '')
      prefix = string.format('%%#WinBarDir#%s %s%s', folder_icon, prefix, separator)
    end
  end

  -- Remove leading slash.
  path = path:gsub('^/', '')

  return table.concat {
    ' ',
    prefix,
    table.concat(
      vim.iter(vim.split(path, '/'))
      :map(function(segment)
        return string.format('%%#Winbar#%s', segment)
      end)
      :totable(),
      separator
    ),
  }
end

vim.api.nvim_create_autocmd('BufWinEnter', {
  group = vim.api.nvim_create_augroup('user-winbar', { clear = true }),
  desc = 'Attach winbar',
  callback = function(args)
    if
        not vim.api.nvim_win_get_config(0).zindex     -- Not a floating window
        and vim.bo[args.buf].buftype == ''            -- Normal buffer
        and vim.api.nvim_buf_get_name(args.buf) ~= '' -- Has a file name
        and not vim.wo[0].diff                        -- Not in diff mode
    then
      Snacks.win.new({
        position = "right",
        -- max_height = 0.5,
        -- max_width = 0.5,
        col = 0.2,
        row = 0.2,
        ft = "md",
        border = "rounded",
        text = M.render(),
        resize = true,
        styles = {
          width = 30,
          height = 100,
          bo = { buftype = "", buflisted = false, bufhidden = "hide", swapfile = false },
          minimal = false,
          noautocmd = false,
          position = "right",
          zindex = 20,
          wo = { winhighlight = "NormalFloat:Normal" },
          border = "rounded",
          title_pos = "center",
          footer_pos = "center",
        }
      })
    end
  end,
})

return M
