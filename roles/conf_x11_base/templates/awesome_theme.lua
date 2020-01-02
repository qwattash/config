-- Template file for awesome themes
-- Author: qwattash
-- Based on the default theme docs at https://awesomewm.org/doc/api/sample%20files/theme.lua.html

local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local theme = {}

theme.font = "AnonymousProLHQwattash 10"

-- %%base16_template: awesomewm##default %%

-- Template colors for awesome theme
local base00 = "#383838"
local base01 = "#404040"
local base02 = "#606060"
local base03 = "#6f6f6f"
local base04 = "#808080"
local base05 = "#dcdccc"
local base06 = "#c0c0c0"
local base07 = "#ffffff"
local base08 = "#dca3a3"
local base09 = "#dfaf8f"
local base0A = "#e0cf9f"
local base0B = "#5f7f5f"
local base0C = "#93e0e3"
local base0D = "#7cb8bb"
local base0E = "#dc8cc3"
local base0F = "#000000"

-- %%base16_template_end%%

theme.bg_normal   = base00
theme.bg_focus    = base07
theme.bg_urgent   = base00
theme.bg_minimize = base00
theme.bg_systray  = base00

theme.fg_normal   = base07
theme.fg_focus    = base0B
theme.fg_urgent   = base01
theme.fg_minimize = base07

theme.useless_gap   = dpi(0)
theme.border_width  = dpi(1)
theme.border_normal = base07
theme.border_focus  = base0B
theme.border_marked = base03

local theme_path = "~/{{ user_local_confdir }}/awesome/theme/"
theme.layout_tile       = theme_path .. "icons/tile.png"
theme.layout_tileleft   = theme_path .. "icons/tileleft.png"
theme.layout_tilebottom = theme_path .. "icons/tilebottom.png"
theme.layout_tiletop    = theme_path .. "icons/tiletop.png"
theme.layout_fairv      = theme_path .. "icons/fairv.png"
theme.layout_fairh      = theme_path .. "icons/fairh.png"
theme.layout_spiral     = theme_path .. "icons/spiral.png"
theme.layout_dwindle    = theme_path .. "icons/dwindle.png"
theme.layout_max        = theme_path .. "icons/max.png"
theme.layout_fullscreen = theme_path .. "icons/fullscreen.png"
theme.layout_magnifier  = theme_path .. "icons/magnifier.png"
theme.layout_floating   = theme_path .. "icons/floating.png"
theme.layout_cornernw   = theme_path .. "icons/cornernw.png"
theme.layout_cornerne   = theme_path .. "icons/cornerne.png"
theme.layout_cornersw   = theme_path .. "icons/cornersw.png"
theme.layout_cornerse   = theme_path .. "icons/cornerse.png"

return theme
