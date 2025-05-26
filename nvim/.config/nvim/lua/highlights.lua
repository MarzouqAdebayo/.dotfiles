vim.opt.termguicolors = true

local colors = require "oldtale.palette"
local bg_transparent = { bg = colors.none }
local border_colors = { bg = colors.none, fg = colors.blend_orange }
local border_colors_bright = { bg = colors.none, fg = colors.magenta }
local none = { bg = colors.none, fg = colors.none }
-- local bright = { bg = colors.orange, fg = colors.black }

local hl = {
    NormalFloat = bg_transparent,
    FloatBorder = border_colors,
    SignColumn = none,

    WinBar = bg_transparent,

    -- blink-cmp
    BlinkCmpMenu = { bg = colors.none, fg = colors.fg },
    BlinkCmpMenuBorder = { fg = colors.blend_orange },
    BlinkCmpMenuSelection = { bg = colors.blend_orange, fg = colors.orange },
    BlinkCmpScrollBarThumb = { bg = colors.blend_orange },
    BlinkCmpScrollBarGutter = { bg = colors.none },
    BlinkCmpDoc = { bg = colors.none, fg = colors.fg },
    BlinkCmpDocSeparator = { bg = colors.none, fg = colors.blend_orange },
    BlinkCmpDocBorder = { fg = colors.blend_orange },

    -- lsp-saga
    SagaNormal = bg_transparent,
    SagaBorder = border_colors_bright,

    -- ActionPreviewNormal = bg_transparent,
    ActionPreviewBorder = border_colors,

    -- DiagnosticNormal = bg_transparent,
    -- DiagnosticBorder = border_colors_bright,
    -- DiagnosticShowNormal = bg_transparent,
    -- DiagnosticShowBorder = border_colors_bright,
}

local function init_highlights()
    for group, conf in pairs(hl) do
        vim.api.nvim_set_hl(0, group, conf)
    end
end


return {
    init_highlights = init_highlights
}
