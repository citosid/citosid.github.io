---
title: WezTerm Configuration
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
