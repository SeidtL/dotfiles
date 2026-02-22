local wezterm = require 'wezterm'
local cfg = {}
if wezterm.config_builder then
    cfg = wezterm.config_builder()
end

-- sys
cfg.check_for_updates = false

-- font
cfg.font = wezterm.font_with_fallback {
  'FiraCode Nerd Font Mono',
  'Noto Sans CJK SC',
}
cfg.font_size = 14
cfg.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }

-- windows
cfg.initial_cols = 110
cfg.initial_rows = 25
cfg.audible_bell = "Disabled"
cfg.window_padding = { left = 5, right = 15, top = 5, bottom = 5 }
cfg.window_background_image_hsb = { brightness = 0.8, hue = 1.0, saturation = 1.0 }
cfg.enable_scroll_bar = true
cfg.window_background_opacity = 0.80
cfg.window_decorations = "INTEGRATED_BUTTONS|RESIZE"

-- theme
local materia = wezterm.color.get_builtin_schemes()['Ocean Dark (Gogh)']
materia.scrollbar_thumb = '#cccccc'
cfg.colors = materia

-- shell
if wezterm.target_triple:find("windows") then
  cfg.default_prog = { 'C:\\Program Files\\PowerShell\\7\\pwsh.exe' }
else
  cfg.default_prog = { '/usr/bin/zsh', "-l" }
end
cfg.tab_max_width = 20

-- key bindings
cfg.disable_default_key_bindings = true
local act = wezterm.action
cfg.mouse_bindings = {
  {
    event = { Down = { streak = 1, button = "Right" } },
    mods = "NONE",
    action = wezterm.action_callback(function(window, pane)
      local has_selection = window:get_selection_text_for_pane(pane) ~= ""
      if has_selection then
        window:perform_action(act.CopyTo("ClipboardAndPrimarySelection"), pane)
        window:perform_action(act.ClearSelection, pane)
      else
        window:perform_action(act({ PasteFrom = "Clipboard" }), pane)
      end
    end),
  },
}

cfg.keys = {
  { key = 'Tab', mods = 'SHIFT|CTRL', action = act.ActivateTabRelative(1) },
  { key = 'F11', mods = 'NONE', action = act.ToggleFullScreen },
  { key = '+', mods = 'SHIFT|CTRL', action = act.IncreaseFontSize },
  { key = '_', mods = 'SHIFT|CTRL', action = act.DecreaseFontSize },
  { key = 'C', mods = 'SHIFT|CTRL', action = act.CopyTo 'Clipboard' },
  { key = 'T', mods = 'SHIFT|CTRL', action = act.ShowLauncher },
  { key = 'Enter', mods = 'SHIFT|CTRL', action = act.ShowLauncherArgs { flags = 'FUZZY|TABS|LAUNCH_MENU_ITEMS' } },
  { key = 'V', mods = 'SHIFT|CTRL', action = act.PasteFrom 'Clipboard' },
  { key = 'W', mods = 'SHIFT|CTRL', action = act.CloseCurrentTab{ confirm = false } },
  { key = 'PageUp', mods = 'SHIFT|CTRL', action = act.ScrollByPage(-1) },
  { key = 'PageDown', mods = 'SHIFT|CTRL', action = act.ScrollByPage(1) },
  { key = 'UpArrow', mods = 'SHIFT|CTRL', action = act.ScrollByLine(-1) },
  { key = 'DownArrow', mods = 'SHIFT|CTRL', action = act.ScrollByLine(1) },
  { key = '"', mods = 'CTRL|SHIFT', action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' }, },
  { key = '%', mods = 'CTRL|SHIFT', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
},
  { key = '(', mods = 'CTRL|SHIFT', action = act.PaneSelect { alphabet = '1234567890', }, },
  { key = '*', mods = 'CTRL|SHIFT', action = wezterm.action.TogglePaneZoomState, },
}
return cfg
