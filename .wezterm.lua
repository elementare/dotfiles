
local wezterm = require("wezterm")
return {
  -- Environment
  set_environment_variables = {
    TERM = "xterm-256color",
  },

  -- Window Appearance
  window_decorations = "NONE",
  enable_tab_bar = false,
  disable_default_key_bindings = true, 
  window_background_opacity = 0.90,
  adjust_window_size_when_changing_font_size = false,
  initial_cols = 120,
  initial_rows = 30,
  enable_scroll_bar = false,

  -- Padding
  window_padding = {
    left = 15,
    right = 15,
    top = 15,
    bottom = 15,
  },

  -- Cursor Configuration
  default_cursor_style = "BlinkingBar",
  cursor_blink_rate = 200,
  cursor_blink_ease_in = 'Constant',
  cursor_blink_ease_out = 'Constant',
  force_reverse_video_cursor = true,

  -- Scrolling
  scrollback_lines = 10000,

  -- Font Configuration
  font = wezterm.font("JetBrainsMono NF"),
  font_size = 14,
  harfbuzz_features = { "calt=0", "clig=0", "liga=0" },


  -- Colorscheme (Tokyo Night)
  colors = {
    foreground = "#a9b1d6",
    background = "#1a1b26",

    cursor_bg = "#bb9af7",
    cursor_border = "#bb9af7",
    cursor_fg = "#1a1b26",

    selection_fg = "#1a1b26",
    selection_bg = "#bb9af7",

    ansi = {
      "#32344a", -- black
      "#f7768e", -- red
      "#9ece6a", -- green
      "#e0af68", -- yellow
      "#7aa2f7", -- blue
      "#ad8ee6", -- magenta
      "#449dab", -- cyan
      "#787c99", -- white
    },

    brights = {
      "#444b6a", -- bright black
      "#ff7a93", -- bright red
      "#b9f27c", -- bright green
      "#ff9e64", -- bright yellow
      "#7da6ff", -- bright blue
      "#bb9af7", -- bright magenta
      "#0db9d7", -- bright cyan
      "#acb0d0", -- bright white
    },
  },

  -- Bell (Error Sound)
  audible_bell = "Disabled",
  command_palette_bg_color = "#1a1b26",
  visual_bell = {
    fade_in_function = "Linear",
    fade_out_function = "Linear",
    target = "CursorColor",
  },
  
  

  -- Shell
  default_prog = { "zellij", "-l", "welcome" },

  -- Clipboard Configuration
  keys = {
    { key = "c", mods = "CTRL|SHIFT", action = wezterm.action.CopyTo("Clipboard") },
    { key = "v", mods = "CTRL|SHIFT", action = wezterm.action.PasteFrom("Clipboard") },
    { key = "=", mods = "CTRL", action = wezterm.action.IncreaseFontSize },
    { key = "-", mods = "CTRL", action = wezterm.action.DecreaseFontSize },
  },

  -- Live Config Reload (WezTerm does this by default)
}

