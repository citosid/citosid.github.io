---
title: "WezTerm Configuration 2: UI"
date: 2024-12-25
---

In order to configure the WezTerm to have a nicer style, create the file `ui.lua` and update your `wezterm.lua` file
like this:

```lua
-- ... the previous Configuration
local ui = require("ui")

ui.set_ui(config)
ui.set_smart_splits(config)
```

And in the `ui.lua` file add:

```lua
local wezterm = require("wezterm")

---@class WezModule
local M = {}

---@type number|nil
M.last_tab = nil

---@param tab_info table
---@return string
local function get_tab_title(tab_info)
 local title = tab_info.tab_title
 return (title and #title > 0) and title or tab_info.active_pane.title
end

---@param window table
local function create_workspace_status(window)
 local status = {
  background = { Background = { Color = "rgba(35, 33, 54, 0.95)" } },
  arrow = { Foreground = { Color = "rgba(35, 33, 54, 0.95)" } },
 }

 if window:leader_is_active() then
  status.background = { Background = { Color = "#eb6f92" } }
 end

 if window:active_tab():tab_id() ~= 0 then
  status.arrow = { Foreground = { Color = "#1e2030" } }
 end

 return status
end

---@param battery_state string
---@return string
local function get_battery_icon(battery_state)
 local icons = {
  ["AC attached"] = "🔌",
  ["Full"] = "🔌",
  ["Unknown"] = "🔌",
  ["Finishing charge"] = "🔌",
  ["Charging"] = "🔌",
  ["Discharging"] = "🔋",
  ["Battery Warning"] = "🪫",
 }
 return icons[battery_state] or "🔋"
end

---@param time_seconds number
---@return string
local function format_time_remaining(time_seconds)
 if time_seconds <= 0 then
  return ""
 end
 local hours = math.floor(time_seconds / 3600)
 local minutes = math.floor((time_seconds % 3600) / 60)
 return string.format(" ⏳%02d:%02d", hours, minutes)
end

---@param battery table
---@return string
local function format_battery_info(battery)
 local icon = get_battery_icon(battery.state)
 local percentage = string.format("%.0f%%", battery.state_of_charge * 100)
 local time_remaining = 0

 if battery.state == "Discharging" then
  time_remaining = battery.time_to_empty or 0
 elseif battery.state == "Charging" then
  time_remaining = battery.time_to_full or 0
 end

 return string.format(" %s%s%s", icon, percentage, format_time_remaining(time_remaining))
end

---@class StyleColors
---@field edge string
---@field background string
---@field foreground string

---@param text string
---@param colors StyleColors
---@return table[]
local function create_styled_section(text, colors)
 return {
  { Background = { Color = colors.edge } },
  { Foreground = { Color = colors.background } },
  { Text = "" },
  { Background = { Color = colors.background } },
  { Foreground = { Color = colors.foreground } },
  { Text = text },
  { Background = { Color = colors.edge } },
  { Foreground = { Color = colors.background } },
  { Text = "" },
 }
end

---@param window table
local function update_right_status(window)
 local colors = {
  edge = "rgba(35, 33, 54, 0.95)",
  background = "#9ccfd8",
  foreground = "#2e3440",
 }

 local date = wezterm.strftime("📅 %b, %d ")
 local time = wezterm.strftime("🕓 %H:%M ")
 local battery = ""

 for _, b in ipairs(wezterm.battery_info()) do
  battery = battery .. format_battery_info(b)
 end

 local components = { { Text = "" } }
 local sections = { date, time, battery }

 for i, section in ipairs(sections) do
  for _, item in ipairs(create_styled_section(section, colors)) do
   table.insert(components, item)
  end

  if i < #sections then
   table.insert(components, { Text = " " })
   table.insert(components, { Text = "" })
  end
 end

 window:set_right_status(wezterm.format(components))
end

---@param tab table
---@param max_width number
---@return table
local function format_tab(tab, max_width)
 local colors = {
  edge = "rgba(35, 33, 54, 0.95)",
  background = tab.is_active and "#ebbcba" or "#232136",
  foreground = tab.is_active and "#2e3440" or "#d8dee9",
 }

 local icon = tab.is_active and "💻" or "🖥️"
 local title = wezterm.truncate_right(get_tab_title(tab), max_width - 2)

 return create_styled_section(icon .. " " .. title, colors)
end
---@param config table
function M.set_ui(config)
 wezterm.on("update-status", function(window, _)
  local status = create_workspace_status(window)
  local workspace_text = "   " .. window:active_workspace() .. " "

  window:set_left_status(wezterm.format({
   status.background,
   { Text = workspace_text },
   status.arrow,
   { Text = "" },
  }))

  update_right_status(window)
 end)

 wezterm.on("format-tab-title", function(tab, _, _, _, _, max_width)
  return format_tab(tab, max_width)
 end)

 return config
end

---@param pane table
---@return boolean
local function is_vim(pane)
 return pane:get_user_vars().IS_NVIM == "true"
end

---@param key string
---@return string
local function get_direction(key)
 local directions = { h = "Left", j = "Down", k = "Up", l = "Right" }
 return directions[key]
end

---@param resize_or_move "resize"|"move"
---@param key string
---@return table
local function create_split_nav(resize_or_move, key)
 local mods = resize_or_move == "resize" and "META" or "CTRL"

 return {
  key = key,
  mods = mods,
  action = wezterm.action_callback(function(win, pane)
   if is_vim(pane) then
    win:perform_action({
     SendKey = { key = key, mods = mods },
    }, pane)
   else
    local action = resize_or_move == "resize" and { AdjustPaneSize = { get_direction(key), 3 } }
     or { ActivatePaneDirection = get_direction(key) }
    win:perform_action(action, pane)
   end
  end),
 }
end

---@param config table
function M.set_smart_splits(config)
 local keys = { "h", "j", "k", "l" }
 for _, key in ipairs(keys) do
  table.insert(config.keys, create_split_nav("move", key))
  table.insert(config.keys, create_split_nav("resize", key))
 end
end

return M
```
