---
title: "WezTerm Configuration 1: Projects Selector"
date: 2024-12-25
---

In this post I'll add my configuration for WezTerm. At the end, it will look like this:

{{< image src="wezterm.png" alt="WezTerm" position="center" style="border-radius: 2px;" >}}

## Setting up keybindings

The first step is to add a key binding. In our case, it will be `LEADER + p` where `LEADER` will be mapped to
`CTRL + a`.

In your `.wezterm.lua` file add:

```lua
local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 2000 }
config.keys = {
  {
    mods = "LEADER",
    key = "p",
    action = wezterm.action_callback(function(window, pane)
    end),
  },
}
```

With this configuration, now you'll be able to type `CTRL + a` then `p` and it will... not do nothing.

In order for this configuration to actually do something, we need more code. Add a new file in the same
folder where your `.wezterm.lua` file is located called `utils.lua`. In this file, add the following code:

```lua
local M = {}

M.get_directories = function(path, level)
 local directories = {}
 level = level or 0
 if level > 1 then
  return directories
 end

 -- Use safer path handling
 local sanitized_path = string.gsub(path, '"', '\\"')
 local p = io.popen('find "' .. sanitized_path .. '" -maxdepth 1 -mindepth 1 \\( -type d -o -type l \\)')

 if not p then
  wezterm.log_warn("Failed to open directory: " .. path)
  return directories
 end

 for file in p:lines() do
  local dir_name = file:match("([^/]+)$")
  if dir_name then
   table.insert(directories, {
    label = file,
    id = dir_name,
   })

   -- Recursively get subdirectories
   local subdirs = M.get_directories(file, level + 1)
   for _, subdir in ipairs(subdirs) do
    table.insert(directories, subdir)
   end
  end
 end

 p:close()
 return directories
end

M.open_project = function(window, _, id, label)
 local mux = wezterm.mux

 if not label then
  wezterm.log_info("Project selection cancelled")
  return
 end

 wezterm.emit("tab-changed", window)

 local workspace = label:match("([^/]+)/[^/]+$")

 -- Find existing window for workspace
 local target_window = nil
 for _, win in ipairs(mux.all_windows()) do
  if win:get_workspace() == workspace then
   target_window = win
   break
  end
 end

 -- Create new window if needed
 if not target_window then
  local _, _, new_window = mux.spawn_window({
   cwd = label,
   workspace = workspace,
  })
  target_window = new_window
  target_window:set_title(workspace)

  -- Set title for initial tab
  local tabs = target_window:tabs()
  for _, tab in ipairs(tabs) do
   tab:set_title(id)
   wezterm.log_info("Created new tab:", tab:get_title())
  end
 end

 -- Find existing tab or create new one
 local target_tab = nil
 for _, tab in ipairs(target_window:tabs()) do
  if tab:get_title() == id then
   target_tab = tab
   wezterm.log_info("Found existing tab")
   break
  end
 end

 if not target_tab then
  target_tab = target_window:spawn_tab({ cwd = label })
  target_tab:set_title(id)
 end

 target_tab:activate()
 mux.set_active_workspace(workspace)
end

M.show_projects = function(window, pane)
 local choices_work = M.get_directories("/Users/username/work", 0)
 local choices_personal = M.get_directories("/Users/username/personal", 0)

 local choices = {}

 for _, v in ipairs(choices_work) do
  table.insert(choices, v)
 end

 for _, v in ipairs(choices_personal) do
  table.insert(choices, v)
 end

 window:perform_action(
  wezterm.action.InputSelector({
   action = wezterm.action_callback(M.open_project),
   choices = choices,
   fuzzy = true,
   title = "💡 Choose a project",
  }),
  pane
 )
end

return M
```

And update the keys to:

```lua {hl_lines=[3,10]}
local wezterm = require("wezterm")
local config = wezterm.config_builder()
local utils = require("utils")

config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 2000 }
config.keys = {
  {
    mods = "LEADER",
    key = "p",
    action = wezterm.action_callback(utils.show_projects),
  },
}
```

Now you'll be able to automatically open your projects in different tabs in different windows separated by workspaces.

However, how to go back to the one you already opened? This code will automatically move you to the one you had opened
if it exists. But, if you want to see which tabs you have open, that'll be done in the next entry.
