# UI Refactor — Project Summary

## Artifacts

| File | Purpose |
|------|---------|
| `rough-idea.md` | Problem statement and constraints |
| `idea-honing.md` | 9 requirements questions and answers |
| `research/color-mapping.md` | Dotfiles theme → CSS variable mapping |
| `research/theme-switcher.md` | FOUC-free localStorage approach |
| `design/detailed-design.md` | Full design with architecture, palettes, error handling |
| `implementation/plan.md` | 7-step incremental implementation plan |

## Design Summary

Replace the macOS-window-chrome terminal aesthetic with a hybrid:
Linear-inspired clean layout + terminal texture (monospace, nav prompts,
phosphor glow). Add 13-theme switcher ported from the dotfiles
ecosystem using `data-theme` CSS attribute switching with localStorage
persistence.

## Implementation Overview

7 steps, each producing demoable functionality:

1. Theme CSS variables (all 13 palettes)
2. Blocking theme init script (no FOUC)
3. Layout overhaul (header, footer, no window chrome)
4. Template updates (remove per-page prompts)
5. Typography and post styling (glow, hover accents)
6. Theme switcher dropdown UI
7. Verify and document

## Next Steps

- Begin implementation at Step 1
- Each step can be committed independently
- Run `hugo server` after each step to verify

## Areas for Future Refinement

- Syntax highlighting (Chroma) colors could be themed per-palette
  (currently hardcoded in code.css)
- Image shortcode frames could adopt theme colors
- A `dotfiles theme generate` adapter could auto-generate the website
  CSS block for new themes
