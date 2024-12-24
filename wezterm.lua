local wezterm = require 'wezterm'
local c = {}
if wezterm.config_builder then
    c = wezterm.config_builder()
end

c.initial_cols = 110
c.initial_rows = 25
c.font = wezterm.font 'FiraCode Nerd Font Mono'
local materia = wezterm.color.get_builtin_schemes()['Material Darker (base16)']
materia.scrollbar_thumb = '#cccccc'
c.colors = materia
c.window_background_opacity = 0.9
c.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
c.window_padding = { left = 0, right = 15, top = 0, bottom = 0 }
c.enable_scroll_bar = true
if wezterm.target_triple:find("windows") then 
    c.default_prog = { 'C:\\Program Files\\PowerShell\\7\\pwsh.exe' }
else
    c.default_prog = { '/bin/zsh', "-l" }
end 
c.tab_max_width = 20

c.disable_default_key_bindings = true
local act = wezterm.action
c.keys = {
  -- Ctrl+Shift+Tab 遍历 tab
  { key = 'Tab', mods = 'SHIFT|CTRL', action = act.ActivateTabRelative(1) },
  -- F11 切换全屏
  { key = 'F11', mods = 'NONE', action = act.ToggleFullScreen },
  -- Ctrl+Shift++ 字体增大
  { key = '+', mods = 'SHIFT|CTRL', action = act.IncreaseFontSize },
  -- Ctrl+Shift+- 字体减小
  { key = '_', mods = 'SHIFT|CTRL', action = act.DecreaseFontSize },
  -- Ctrl+Shift+C 复制选中区域
  { key = 'C', mods = 'SHIFT|CTRL', action = act.CopyTo 'Clipboard' },
  -- Ctrl+Shift+N 新窗口
  { key = 'N', mods = 'SHIFT|CTRL', action = act.SpawnWindow },
  -- Ctrl+Shift+T 新 tab
  { key = 'T', mods = 'SHIFT|CTRL', action = act.ShowLauncher },
  -- Ctrl+Shift+Enter 显示启动菜单
  { key = 'Enter', mods = 'SHIFT|CTRL', action = act.ShowLauncherArgs { flags = 'FUZZY|TABS|LAUNCH_MENU_ITEMS' } },
  -- Ctrl+Shift+V 粘贴剪切板的内容
  { key = 'V', mods = 'SHIFT|CTRL', action = act.PasteFrom 'Clipboard' },
  -- Ctrl+Shift+W 关闭 tab 且不进行确认
  { key = 'W', mods = 'SHIFT|CTRL', action = act.CloseCurrentTab{ confirm = false } },
  -- Ctrl+Shift+PageUp 向上滚动一页
  { key = 'PageUp', mods = 'SHIFT|CTRL', action = act.ScrollByPage(-1) },
  -- Ctrl+Shift+PageDown 向下滚动一页
  { key = 'PageDown', mods = 'SHIFT|CTRL', action = act.ScrollByPage(1) },
  -- Ctrl+Shift+UpArrow 向上滚动一行
  { key = 'UpArrow', mods = 'SHIFT|CTRL', action = act.ScrollByLine(-1) },
  -- Ctrl+Shift+DownArrow 向下滚动一行
  { key = 'DownArrow', mods = 'SHIFT|CTRL', action = act.ScrollByLine(1) },
  {
    key = '"',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  {
    key = '%',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = '(',
    mods = 'CTRL|SHIFT',
    action = act.PaneSelect {
      alphabet = '1234567890',
    },
  },
  {
    key = '*',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.TogglePaneZoomState,
  },
}
return c
