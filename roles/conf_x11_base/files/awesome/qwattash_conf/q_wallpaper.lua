--- Wallpaper configuration

local beautiful = require("beautiful")
local gears = require("gears")
local awful = require("awful")

local M = {}

local function set_wallpaper(s)
  -- Wallpaper
  if beautiful.wallpaper then
    local wallpaper = beautiful.wallpaper
    -- If wallpaper is a function, call it with the screen
    if type(wallpaper) == "function" then
      wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)
  end
end

local function initWallpaper()
  -- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
  screen.connect_signal("property::geometry", set_wallpaper)

  -- Set initial wallpaper for all screens
  awful.screen.connect_for_each_screen(function(s)
      set_wallpaper(s)
  end)
end
M.initWallpaper = initWallpaper

return M
