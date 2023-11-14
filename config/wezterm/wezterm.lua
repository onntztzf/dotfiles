-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
    config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

-- Enable automatic checking for updates
config.check_for_updates = true
-- Set the interval for checking updates to once a day (in seconds)
config.check_for_updates_interval_seconds = 86400

-- Enable the scroll bar
config.enable_scroll_bar = true

-- Hide the tab bar if only one tab is open
config.hide_tab_bar_if_only_one_tab = true

-- Configure window padding
config.window_padding = {
    left = 5,
    right = 5,
    top = 0,
    bottom = 0
}

-- Set the background opacity for the window
config.window_background_opacity = 0.8

-- Configure HarfBuzz features for text rendering
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }

-- Alias for wezterm.action for brevity
local act = wezterm.action

-- Define keybindings for various actions
config.keys = {
    -- Split the current pane horizontally
    {
        key = '%',
        mods = 'CTRL|SHIFT|ALT',
        action = wezterm.action.SplitHorizontal {
            domain = 'CurrentPaneDomain'
        }
    },
    -- Split the current pane vertically
    {
        key = '"',
        mods = 'CTRL|SHIFT|ALT',
        action = wezterm.action.SplitVertical {
            domain = 'CurrentPaneDomain'
        }
    },
    -- Move the current tab to the left
    {
        key = '{',
        mods = 'SHIFT|ALT',
        action = act.MoveTabRelative(-1)
    },
    -- Move the current tab to the right
    {
        key = '}',
        mods = 'SHIFT|ALT',
        action = act.MoveTabRelative(1)
    },
    -- Activate the tab to the left
    {
        key = '{',
        mods = 'ALT',
        action = act.ActivateTabRelative(-1)
    },
    -- Activate the tab to the right
    {
        key = '}',
        mods = 'ALT',
        action = act.ActivateTabRelative(1)
    },
    -- Activate the pane to the left
    {
        key = 'LeftArrow',
        mods = 'CTRL|SHIFT',
        action = act.ActivatePaneDirection 'Left'
    },
    -- Activate the pane to the right
    {
        key = 'RightArrow',
        mods = 'CTRL|SHIFT',
        action = act.ActivatePaneDirection 'Right'
    },
    -- Activate the pane above
    {
        key = 'UpArrow',
        mods = 'CTRL|SHIFT',
        action = act.ActivatePaneDirection 'Up'
    },
    -- Activate the pane below
    {
        key = 'DownArrow',
        mods = 'CTRL|SHIFT',
        action = act.ActivatePaneDirection 'Down'
    }
}

-- Finally, return the configuration to wezterm
return config
