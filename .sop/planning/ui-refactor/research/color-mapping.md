# Research: Theme Color Mapping

## Problem

Map the dotfiles 16-color ANSI palette (kitty conf format) to the
website's 12 semantic CSS custom properties.

## Dotfiles Palette Structure (per theme)

From kitty configs, each theme provides:

| Kitty Field | Role |
|-------------|------|
| `background` | Page background |
| `color0` (black) | Deepest dark |
| `color8` (bright black) | Muted/border color |
| `foreground` | Primary text |
| `color7` (white) | Secondary text |
| `color15` (bright white) | Primary text (same as fg) |
| `color1` (red) | Error/love accent |
| `color3` (yellow) | Warning/gold accent |
| `color11` (bright yellow) | Lighter gold |
| `color5` (magenta) | Keyword/iris accent |
| `color6` (cyan) | Primary accent (links, foam) |
| `color4` (blue) | Secondary blue accent (pine) |
| `color2` (green) | Tertiary accent |
| `active_border_color` | Highlight accent |

From sketchybar Lua themes, there's also a semantic layer:

| Sketchybar Field | Role |
|------------------|------|
| `base` | Background |
| `surface1` | Surface |
| `overlay0` | Overlay/borders |
| `text` | Primary text |
| `subtext1` | Subtle text |
| `subtext0` | Muted text |
| `red/flamingo` | Love/error |
| `peach` | Gold/warning |
| `mauve` | Iris/keywords |
| `teal/sky` | Foam/links |
| `green/blue` | Pine/operators |
| `lavender` | Hover/rose |

## Proposed CSS Variable Mapping

| CSS Variable | Source (kitty) | Source (sketchybar) |
|-------------|----------------|---------------------|
| `--base` | `background` | `base` |
| `--surface` | `inactive_tab_background` | `surface1` |
| `--overlay` | `color8` (bright black) | `overlay0` |
| `--text` | `foreground` | `text` |
| `--subtle` | `color7` (white) | `subtext1` |
| `--muted` | `color8` (bright black) | `overlay2` |
| `--love` | `color1` (red) | `red` |
| `--gold` | `color3` (yellow) | `peach` |
| `--rose` | `color11` (bright yellow) | `rosewater` |
| `--pine` | `color4` (blue) | `blue` |
| `--foam` | `color6` (cyan) | `sky` |
| `--iris` | `color5` (magenta) | `mauve` |

## Decision

Use the kitty config as the source of truth since it has the cleanest
hex values. The sketchybar Lua uses `0xff` prefixed ARGB integers which
would need conversion. Kitty configs are plain `#hex` — ready to paste
into CSS.
