--
-- Main Awesome WM configuration.
-- This imports different modules to add functionality.
--

package.path = package.path .. ";{{ ansible_env.HOME }}/{{ user_local_confdir }}/awesome/?.lua"

local awful = require("awful")
require("awful.autofocus")
local beautiful = require("beautiful")
local naughty = require("naughty")

local q_keyboard = require("qwattash_conf/q_keyboard")
local q_layout = require("qwattash_conf/q_layout")
local q_menubar = require("qwattash_conf/q_menubar")
local q_rules = require("qwattash_conf/q_rules")
local q_signals = require("qwattash_conf/q_signals")
local q_wallpaper = require("qwattash_conf/q_wallpaper")

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

beautiful.init("~/{{ user_local_confdir }}/awesome/theme/theme.lua")

q_keyboard.initKeyBindings()
q_layout.initLayouts()
q_menubar.initMenuBar()
q_wallpaper.initWallpaper()
q_signals.initSignals()
q_rules.initRules()
