local DEFAULT_ACTIVE_FG = "#b4b1ba"
local DEFAULT_INACTIVE_FG = "#3a3a3e"
local DEFAULT_BG = "#121213"
local FONT_SIZE = 10
local WINDOW_FONTS_SIZE = 9
local WINDOW_FONTS = {
	{ family = "BlexMono Nerd Font", weight = "Black", stretch = "UltraCondensed" },
	{ family = "Lilex Nerd Font", weight = "Black", stretch = "UltraCondensed" },
}
local CONSOLE_FONTS = {
	{ family = "BlexMono Nerd Font", weight = "Regular", stretch = "UltraCondensed" },
	{ family = "Lilex Nerd Font", weight = "Regular", stretch = "UltraCondensed" },
	{ family = "Source Code Pro", weight = "Regular", stretch = "UltraCondensed" },
	{ family = "Maple Mono", weight = "Regular", stretch = "UltraCondensed" },
	{ family = "Source Code Pro", weight = "Regular", stretch = "UltraCondensed" },
}

local function retrieve_font_settings(fonts)
	local DEFAULT_WEIGHT = "Regular"
	local DEFAULT_STRETCH = "Normal"
	local converted = {}
	for i, font in ipairs(fonts) do
		converted[i] =
			{ family = font.family, weight = font.weight or DEFAULT_WEIGHT, stretch = font.stretch or DEFAULT_STRETCH }
	end
	return converted
end

local wezterm = require("wezterm")
local keymaps = require("keymaps")
local mouse_bindings = require("mouse_bindings")
require("status")

return {
	front_end = "WebGpu",
	-- webgpu_power_preference = "LowPower",

	-- color scheme
	color_scheme_dirs = { "~/.config/wezterm/colors" },
	color_scheme = "oldtale",

	-- colors
	colors = {
		tab_bar = {
			inactive_tab_edge = "none",
			active_tab = {
				bg_color = DEFAULT_BG,
				fg_color = DEFAULT_ACTIVE_FG,
			},
			inactive_tab = {
				bg_color = DEFAULT_BG,
				fg_color = DEFAULT_INACTIVE_FG,
			},
		},
	},

	-- font
	font = wezterm.font_with_fallback(retrieve_font_settings(CONSOLE_FONTS)),
	font_size = FONT_SIZE,
	-- Remove font ligatures with this
	-- harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },
	warn_about_missing_glyphs = false,
	cell_width = 1,
	line_height = 1,
	adjust_window_size_when_changing_font_size = false,

	-- look and feel
	background = {
		{
			source = {
				File = "/home/marzouq/Pictures/Backgrounds/illustration-anime-character-rain.jpg",
				-- File = "/home/marzouq/Pictures/Backgrounds/anime-moon-landscape.jpg",
			},
			attachment = "Fixed",
			hsb = {
				brightness = 0.01,
				hue = 0.8,
				saturation = 0.7,
			},
			opacity = 1.0,
			height = "Cover",
			width = "Cover",
			horizontal_align = "Center",
		},
	},
	window_decorations = "RESIZE",
	macos_window_background_blur = 20,
	use_fancy_tab_bar = true,
	show_new_tab_button_in_tab_bar = false,
	window_frame = {
		active_titlebar_bg = DEFAULT_BG,
		inactive_titlebar_bg = DEFAULT_BG,
		font_size = WINDOW_FONTS_SIZE,
		font = wezterm.font_with_fallback(retrieve_font_settings(WINDOW_FONTS)),
	},

	-- window size
	initial_cols = 80 + 8 * 9,
	initial_rows = 24 + 8 * 3,

	-- bell
	audible_bell = "Disabled",
	visual_bell = {
		fade_in_function = "EaseIn",
		fade_in_duration_ms = 30,
		fade_out_function = "EaseOut",
		fade_out_duration_ms = 30,
	},

	-- status
	status_update_interval = 1000,

	-- misc
	check_for_updates = false,
	native_macos_fullscreen_mode = true,

	-- key settings
	send_composed_key_when_left_alt_is_pressed = false,
	send_composed_key_when_right_alt_is_pressed = false,
	macos_forward_to_ime_modifier_mask = "SHIFT|CTRL",

	-- keymaps
	---- disable default keymaps
	disable_default_key_bindings = true,
	---- set leader_key to achieve tmux-like keybinds
	leader = { mods = "CTRL", key = "t", timeout_milliseconds = 1000 },
	keys = keymaps,
	---- set mouse bindings
	disable_default_mouse_bindings = true,
	mouse_bindings = mouse_bindings,
}
