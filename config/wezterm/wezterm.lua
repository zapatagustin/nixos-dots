local wezterm = require "wezterm"

local config = {
  	font = wezterm.font("Jetbrains Mono Nerd Font"),
    rows = {
    initial_cols = 12,
    initial_rows = 12
  }
}

function scheme_for_appearance(appearance)
  if appearance:find "Dark" then
    return "Catppuccin Macchiato"
  else
    return "Gruvbox light, soft"
  end
end

return {
  -- ...your existing config
  color_scheme = scheme_for_appearance(wezterm.gui.get_appearance()),
}
