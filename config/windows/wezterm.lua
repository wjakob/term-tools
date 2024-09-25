-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.wsl_domains = {
  {
    -- The name of this specific domain.  Must be unique amonst all types
    -- of domain in the configuration file.
    name = 'WSL:Ubuntu',

    -- The name of the distribution.  This identifies the WSL distribution.
    -- It must match a valid distribution from your `wsl -l -v` output in
    -- order for the domain to be useful.
    distribution = 'Ubuntu',
    default_cwd = '/home/wjakob',
},
}
config.default_domain = 'WSL:Ubuntu'
config.font = wezterm.font 'UbuntuMono Nerd Font'

-- For example, changing the color scheme:
config.color_scheme = 'Tomorrow Night'

-- Set graphics card
config.webgpu_preferred_adapter = {
  backend = 'Dx12',
  device = 42912,
  device_type = 'IntegratedGpu',
  name = 'Intel(R) Iris(R) Xe Graphics',
  vendor = 32902,
}

config.front_end = 'WebGpu'
config.hide_tab_bar_if_only_one_tab = true

config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

-- and finally, return the configuration to wezterm
return config
