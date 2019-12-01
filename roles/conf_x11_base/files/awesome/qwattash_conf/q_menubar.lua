--- Menu bar configuration

local awful = require("awful")
local wibox = require("wibox")

local M = {}

--- useless
-- local function getTaglistButtons()
--   local taglist_buttons = awful.util.table.join(
--     awful.button({ }, 1, function(t) t:view_only() end),
--     awful.button({ modkey }, 1, function(t)
--         if client.focus then
--           client.focus:move_to_tag(t)
--         end
--     end),
--     awful.button({ }, 3, awful.tag.viewtoggle),
--     awful.button({ modkey }, 3, function(t)
--         if client.focus then
--           client.focus:toggle_tag(t)
--         end
--     end),
--     awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
--     awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
--   )
--   return taglist_buttons
-- end

-- local function client_menu_toggle_fn()
--   local instance = nil

--   return function ()
--     if instance and instance.wibox.visible then
--       instance:hide()
--       instance = nil
--     else
--       instance = awful.menu.clients({ theme = { width = 250 } })
--     end
--   end
-- end

-- useless
-- local function getTasklistButtons()
--   local tasklist_buttons = awful.util.table.join(
--                      awful.button({ }, 1, function (c)
--                                               if c == client.focus then
--                                                   c.minimized = true
--                                               else
--                                                   -- Without this, the following
--                                                   -- :isvisible() makes no sense
--                                                   c.minimized = false
--                                                   if not c:isvisible() and c.first_tag then
--                                                       c.first_tag:view_only()
--                                                   end
--                                                   -- This will also un-minimize
--                                                   -- the client, if needed
--                                                   client.focus = c
--                                                   c:raise()
--                                               end
--                                           end),
--                      awful.button({ }, 3, client_menu_toggle_fn()),
--                      awful.button({ }, 4, function ()
--                                               awful.client.focus.byidx(1)
--                                           end),
--                      awful.button({ }, 5, function ()
--                                               awful.client.focus.byidx(-1)
--                                           end))
-- end

-- Initialize menu bar widgets for each screen
local function initMenuBar()

  local taglist_buttons = nil -- getTaglistButtons()
  local tasklist_buttons = nil -- getTasklistButtons()

  local kbdLayoutWidget = awful.widget.keyboardlayout()
  local clockWidget = wibox.widget.textclock()

  awful.screen.connect_for_each_screen(function(s)

      -- Each screen has its own tag table.
      awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

      -- Create a promptbox for each screen
      s.mypromptbox = awful.widget.prompt()
      -- Create an imagebox widget which will contains an icon indicating which layout we're using.
      -- We need one layoutbox per screen.
      s.mylayoutbox = awful.widget.layoutbox(s)
      s.mylayoutbox:buttons(awful.util.table.join(
                              awful.button({ }, 1, function () awful.layout.inc( 1) end),
                              awful.button({ }, 3, function () awful.layout.inc(-1) end),
                              awful.button({ }, 4, function () awful.layout.inc( 1) end),
                              awful.button({ }, 5, function () awful.layout.inc(-1) end)))
      -- Create a taglist widget
      s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

      -- Create a tasklist widget
      s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

      -- Create the wibox
      s.mywibox = awful.wibar({ position = "top", screen = s })

      -- Add widgets to the wibox
      s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
          layout = wibox.layout.fixed.horizontal,
          mylauncher,
          s.mytaglist,
          s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
          layout = wibox.layout.fixed.horizontal,
          kbdLayoutWidget,
          wibox.widget.systray(),
          clockWidget,
          s.mylayoutbox,
        },
      }
  end)

end
M.initMenuBar = initMenuBar

return M
