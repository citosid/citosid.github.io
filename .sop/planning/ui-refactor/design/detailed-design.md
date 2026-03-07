# Detailed Design — Terminal Theme Redesign

## Overview

Redesign abrahamsustaita.com from a macOS-window-chrome terminal
aesthetic to a hybrid style: Linear-inspired clean layout with terminal
texture (monospace, prompts in nav, phosphor glow). Add a 13-theme
switcher ported from the dotfiles ecosystem, persisted in localStorage.

## Detailed Requirements

### Layout

- R1: Remove macOS window chrome (traffic-light dots, rounded container)
- R2: Page body IS the terminal — no wrapper frame
- R3: Header: site title left, nav links right (`~/home`, `~/tags`,
  `~/theme`), separated by `1px` border-bottom
- R4: Footer: `visitor@abrahamsustaita.com:~$ echo © 2026 Abraham Sustaita`
- R5: Strip per-page command prompts (`cat`/`ls`) — reversible decision
- R6: Max-width container centered, content flows top-to-bottom

### Post List

- R7: Simple rows — title link left, date right (stacks on mobile)
- R8: Subtle `1px` left border accent on hover
- R9: Tags inline as plain text, not badges
- R10: No cards, no boxes, no shadows

### Visual

- R11: Faint phosphor glow (`text-shadow: 0 0 8px var(--iris)`) on
  site title and `h1` only
- R12: Rosé Pine Moon as default theme
- R13: Follow Uncodixfy rules: no oversized radii, no glassmorphism,
  no dramatic shadows, no hero sections, no pill shapes

### Theme System

- R14: 13 themes ported from dotfiles (kitty configs as source)
- R15: Dropdown selector in header nav
- R16: Persist in localStorage, default to rose-pine
- R17: No FOUC — blocking inline script in `<head>` sets theme before
  first paint

## Architecture Overview

```text
┌─────────────────────────────────────────────┐
│ baseof.html                                 │
│ ┌─────────────────────────────────────────┐ │
│ │ <head>                                  │ │
│ │   inline theme-init.js (blocking)       │ │
│ │   CSS pipeline (Hugo Pipes)             │ │
│ │     variables.css ← theme definitions   │ │
│ │     base.css                            │ │
│ │     terminal.css                        │ │
│ │     typography.css                      │ │
│ │     posts.css                           │ │
│ │     code.css                            │ │
│ │     tables.css                          │ │
│ │     images.css                          │ │
│ │   deferred theme-switcher.js            │ │
│ └─────────────────────────────────────────┘ │
│ <body>                                      │
│   <div id="terminal">                       │
│     <header class="site-header">            │
│       site title | ~/home ~/tags ~/theme    │
│     </header>                               │
│     <main class="terminal-content">         │
│       {{ block "main" }}                    │
│     </main>                                 │
│     <footer class="site-footer">            │
│       visitor@...$ echo © 2026              │
│     </footer>                               │
│   </div>                                    │
│ </body>                                     │
└─────────────────────────────────────────────┘
```

## Components and Interfaces

### CSS Modules (8 files — unchanged count)

| Module | Changes |
|--------|---------|
| `variables.css` | Add 12 `[data-theme]` blocks (one per non-default theme) |
| `base.css` | Remove body padding, simplify to full-terminal feel |
| `terminal.css` | Remove window chrome, add header/footer/nav styles |
| `typography.css` | Add `text-shadow` glow on `h1` and site title |
| `posts.css` | Add row layout with left-border hover accent |
| `code.css` | No changes |
| `tables.css` | No changes |
| `images.css` | No changes |

### New JS Files (2 files)

| File | Purpose | Loading |
|------|---------|---------|
| `assets/js/theme-init.js` | Read localStorage, set `data-theme` | Inline blocking in `<head>` |
| `assets/js/theme-switcher.js` | Dropdown UI, click handler, save | Deferred `<script>` at end of body |

### Templates

| Template | Changes |
|----------|---------|
| `baseof.html` | Replace window chrome with header/footer, add JS |
| `single.html` | Remove command-line div |
| `list.html` | Remove command-line div, update post row markup |
| `tags.html` | Remove command-line div |
| `tag.html` | Remove command-line div |

## Data Models

### Theme Definition (CSS)

Each theme maps to the same 12 custom properties:

```css
[data-theme="theme-name"] {
  --base: #hex;      /* page background */
  --surface: #hex;   /* container/elevated bg */
  --overlay: #hex;   /* borders, highlights */
  --text: #hex;      /* primary text */
  --subtle: #hex;    /* secondary text */
  --muted: #hex;     /* muted text, borders */
  --love: #hex;      /* errors, red accent */
  --gold: #hex;      /* warnings, yellow accent */
  --rose: #hex;      /* hover, inline code */
  --pine: #hex;      /* prompts, operators */
  --foam: #hex;      /* links, strings */
  --iris: #hex;      /* headings, keywords */
}
```

### Theme Color Extraction (kitty → CSS)

| CSS Variable | Kitty Source |
|-------------|-------------|
| `--base` | `background` |
| `--surface` | `inactive_tab_background` |
| `--overlay` | `color8` |
| `--text` | `foreground` |
| `--subtle` | `color7` |
| `--muted` | `color8` |
| `--love` | `color1` |
| `--gold` | `color3` |
| `--rose` | `color11` |
| `--pine` | `color4` |
| `--foam` | `color6` |
| `--iris` | `color5` |

Note: `--subtle` and `--muted` both map from `color7`/`color8`. For
rose-pine-moon the original values are kept. For auto-generated themes,
`color7` serves as subtle and `color8` as muted.

### All 13 Theme Palettes

| Theme | --base | --surface | --overlay | --text | --subtle | --muted | --love | --gold | --rose | --pine | --foam | --iris |
|-------|--------|-----------|-----------|--------|----------|---------|--------|--------|--------|--------|--------|--------|
| rose-pine | `#232136` | `#2a273f` | `#6e6a86` | `#e0def4` | `#908caa` | `#6e6a86` | `#eb6f92` | `#f6c177` | `#ea9a97` | `#3e8fb0` | `#9ccfd8` | `#c4a7e7` |
| catppuccin-mocha | `#1e1e2e` | `#181825` | `#585b70` | `#cdd6f4` | `#bac2de` | `#585b70` | `#f38ba8` | `#f9e2af` | `#f9e2af` | `#89b4fa` | `#94e2d5` | `#f5c2e7` |
| catppuccin-frappe | `#303446` | `#292c3c` | `#626880` | `#c6d0f5` | `#b5bfe2` | `#626880` | `#e78284` | `#e5c890` | `#e5c890` | `#8caaee` | `#81c8be` | `#f4b8e4` |
| prism | `#0d0f11` | `#1a1e22` | `#4a6a8a` | `#e0e8f0` | `#a0b0c0` | `#4a6a8a` | `#9f1724` | `#e8a54a` | `#edbb77` | `#3b7bc6` | `#7cc3ff` | `#852c6b` |
| crystals | `#0d1011` | `#1a2022` | `#4a6a8a` | `#e0e8f0` | `#a0b0c0` | `#4a6a8a` | `#a13031` | `#e8a54a` | `#edbb77` | `#503090` | `#11bbfe` | `#a13bb1` |
| tron-ares | `#0d0e11` | `#1a1d22` | `#4a6a8a` | `#e0e8f0` | `#a0b0c0` | `#4a6a8a` | `#b10703` | `#c38b4c` | `#cfa372` | `#4a8ac4` | `#43c0c0` | `#c44a8a` |
| enterprise-desert | `#0d0e11` | `#1a1d22` | `#4a6a8a` | `#e0e8f0` | `#a0b0c0` | `#4a6a8a` | `#8f4d23` | `#d0a874` | `#dcbf9a` | `#79a2d2` | `#43c0c0` | `#c44a8a` |
| ai-machine | `#0d0e11` | `#1a1d22` | `#4a6a8a` | `#e0e8f0` | `#a0b0c0` | `#4a6a8a` | `#d71e16` | `#e8a54a` | `#edbb77` | `#4a8ac4` | `#2d91b7` | `#c44a8a` |
| ai-flower | `#0d1011` | `#1a2022` | `#4a6a8a` | `#e0e8f0` | `#a0b0c0` | `#4a6a8a` | `#a65712` | `#855d2c` | `#ab7738` | `#4a8ac4` | `#00a9e4` | `#c5518e` |
| aurora | `#071417` | `#142225` | `#496972` | `#d7e0e2` | `#98a0a2` | `#496972` | `#ce7cc8` | `#bab338` | `#c2db6c` | `#10ace6` | `#00c7d6` | `#8994f4` |
| headphones | `#071418` | `#142226` | `#496973` | `#d7e0e3` | `#98a0a3` | `#496973` | `#d07cc5` | `#b7b43a` | `#bedc6f` | `#1fabe7` | `#00c6d9` | `#8e93f3` |
| fantasy-autumn | `#0f111b` | `#1c1f29` | `#4d6777` | `#dcdee5` | `#9c9ea5` | `#4d6777` | `#dc78ae` | `#f98690` | `#ffa997` | `#52a3f1` | `#00c1ed` | `#ae88e7` |
| color-wall | `#09131a` | `#172128` | `#4b6875` | `#d8dfe4` | `#999fa4` | `#4b6875` | `#d57abd` | `#adb742` | `#b4df78` | `#36a8ec` | `#00c4e1` | `#9b8ff0` |

### localStorage Schema

```
Key:   "theme"
Value: "rose-pine" | "catppuccin-mocha" | ... (theme name string)
```

If key is absent, default to rose-pine (no `data-theme` attribute set,
`:root` values apply).

## Error Handling

- If localStorage is unavailable (private browsing), the default theme
  renders. The switcher still works for the session via `data-theme`
  attribute, it just won't persist.
- If a stored theme name doesn't match any CSS selector, `:root`
  defaults apply (rose-pine).
- The blocking script is wrapped in a try/catch to prevent JS errors
  from blocking page render.

## Testing Strategy

- Manual: run `hugo server`, verify each theme renders correctly by
  cycling through the dropdown
- Manual: verify no FOUC by selecting a non-default theme, reloading
  the page, and confirming the correct theme appears immediately
- Manual: verify localStorage persistence across page navigations
- Manual: verify responsive layout at 768px and 1400px breakpoints
- Manual: verify the dropdown works on mobile (native `<select>`)

## Appendices

### A. Technology Choices

| Choice | Rationale |
|--------|-----------|
| `data-theme` attribute on `<html>` | Proven pattern, CSS-only theme switching, no JS needed for rendering |
| Native `<select>` for dropdown | Uncodixfy compliant (keep it normal), accessible, works on mobile |
| Inline blocking JS | Prevents FOUC, ~100 bytes, no external request |
| Kitty configs as color source | Clean hex values, already maintained, 1:1 mapping to CSS vars |

### B. Alternative Approaches Considered

1. **Separate CSS files per theme** — Rejected: would require 13 CSS
   files and conditional loading, more complex than `data-theme` overrides
2. **JS-based CSS variable injection** — Rejected: more complex, same
   result as `data-theme` with more code
3. **Server-side theme via Hugo params** — Rejected: static site, no
   server-side state

### C. Uncodixfy Compliance Checklist

- [x] No oversized rounded corners (max 8px on code blocks)
- [x] No glassmorphism or glass effects
- [x] No dramatic shadows (max `0 2px 8px rgba(0,0,0,0.1)`)
- [x] No gradient backgrounds
- [x] No pill shapes
- [x] No hero sections
- [x] No badges (tags are plain text)
- [x] No transform animations on hover
- [x] No decorative copy or eyebrow labels
- [x] Simple `1px` borders
- [x] Consistent spacing scale
- [x] Native form elements (select)
- [x] Colors from existing project palette (Rosé Pine Moon + dotfiles)
