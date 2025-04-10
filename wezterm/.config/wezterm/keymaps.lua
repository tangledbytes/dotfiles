local M = {}

M.init = function(config, wezterm)
	config.leader = {
		key = "a",
		mods = "CTRL",
		timeout_milliseconds = 1000,
	}

	config.keys = {
		 -- Tab switching: Ctrl+a, then 1 through 9
		{
		  key = "1",
		  mods = "LEADER",
		  action = wezterm.action.ActivateTab(0),
		},
		{
		  key = "2",
		  mods = "LEADER",
		  action = wezterm.action.ActivateTab(1),
		},
		{
		  key = "3",
		  mods = "LEADER",
		  action = wezterm.action.ActivateTab(2),
		},
		{
		  key = "4",
		  mods = "LEADER",
		  action = wezterm.action.ActivateTab(3),
		},
		{
		  key = "5",
		  mods = "LEADER",
		  action = wezterm.action.ActivateTab(4),
		},
		{
		  key = "6",
		  mods = "LEADER",
		  action = wezterm.action.ActivateTab(5),
		},
		{
		  key = "7",
		  mods = "LEADER",
		  action = wezterm.action.ActivateTab(6),
		},
		{
		  key = "8",
		  mods = "LEADER",
		  action = wezterm.action.ActivateTab(7),
		},
		{
		  key = "9",
		  mods = "LEADER",
		  action = wezterm.action.ActivateTab(8),
		},

		-- New tab (Ctrl+a, then c)
		{
		  key = "c",
		  mods = "LEADER",
		  action = wezterm.action.SpawnTab("CurrentPaneDomain"),
		},

		-- Vertical split (Ctrl+a, then |)
		{
		  key = "-",
		  mods = "LEADER",
		  action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
		},

		-- Horizontal split (Ctrl+a, then -)
		{
		  key = "|",
		  mods = "LEADER",
		  action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
		},

		-- Close current pane (Ctrl+a, then x)
		{
		  key = "x",
		  mods = "LEADER",
		  action = wezterm.action.CloseCurrentPane({ confirm = true }),
		},

		-- Next tab (Ctrl+a, then n)
		{
		  key = "n",
		  mods = "LEADER",
		  action = wezterm.action.ActivateTabRelative(1),
		},

		-- Previous tab (Ctrl+a, then p)
		{
		  key = "p",
		  mods = "LEADER",
		  action = wezterm.action.ActivateTabRelative(-1),
		},

		-- Copy with Cmd+C
		{
		  key = "c",
		  mods = "CMD",
		  action = wezterm.action.CopyTo("Clipboard"),
		},

		-- Paste with Cmd+V
		{
		  key = "v",
		  mods = "CMD",
		  action = wezterm.action.PasteFrom("Clipboard"),
		},

		{
		  key = "s",
		  mods = "LEADER",
		  action = wezterm.action.ShowLauncherArgs({
		    flags = "WORKSPACES",
		  }),
		},

		{
		  key = "r",
		  mods = "LEADER",
		  action = wezterm.action.ReloadConfiguration,
		},

		{
		  key = "q",
		  mods = "CMD",
		  action = wezterm.action.QuitApplication,
		},

		{
		  key = "h",
		  mods = "LEADER",
		  action = wezterm.action.ActivatePaneDirection "Left",
		},
		{
		  key = "l",
		  mods = "LEADER",
		  action = wezterm.action.ActivatePaneDirection "Right",
		},
		{
		  key = "k",
		  mods = "LEADER",
		  action = wezterm.action.ActivatePaneDirection "Up",
		},
		{
		  key = "j",
		  mods = "LEADER",
		  action = wezterm.action.ActivatePaneDirection "Down",
		},

	}
end

return M
