# UI Tightening Pass — Discoveries

Documented: 2026-03-07

## Issues Found and Fixed

### Font Size Scale Was Too Large
- Body was 16px (18px on large screens) — too big for monospace
- Headings ranged from 1rem to 2.25rem — too much variation
- Fixed: body 14px (15px large), h1 1.5rem, h2 1.25rem, h3 1.1rem, h4-h6 1rem

### Container Width Too Wide for Monospace
- Was 1200px (1400px large) — monospace at 14px reads best narrower
- Fixed: 900px (1000px large)

### Blockquote Used --overlay as Background
- `--overlay` is a border/highlight color, not a background color
- Made blockquotes look like muddy blobs
- Fixed: removed background, kept only left border + subtle text color

### Inline Code Was Invisible
- `background-color: var(--base)` = same as page background
- Fixed: changed to `var(--surface)` for subtle contrast

### Post Row Hover Had Layout Shift
- `padding-left` changed from 1rem to 1.25rem on hover
- Combined with `transition: all` — janky and sloppy
- Fixed: only border-color transitions, no padding change

### Image Module Had Decorative Animations
- `filter: brightness(0.97)` with hover transition to 1.0
- `@keyframes imageLoad` fade-in animation
- Both unnecessary — removed

### Single Post Used Emoji in Meta
- 📆 and 📖 in post metadata — gimmicky
- Fixed: plain text with middot separators

### Class Name Collision
- `.post-title` was used as both an h1 class in single.html and a link class in posts.css
- Fixed: renamed link class to `.post-title-link`

## Design Principles Applied
- Monospace terminal blog = smaller type, narrower measure
- Only transition the specific property that changes
- Background colors for containers, border colors for borders — don't mix
- No decorative animations on content elements

## Uncodixfy Audit — 2026-03-07

### Overall Assessment
Site scored well against the Uncodixfy standard. No major Codex-style
patterns found. Terminal blog concept is a genuine design decision.

### Issues Found and Fixed

#### Dead text-shadow glow on site title (typography.css)
- `.site-title a` had `text-shadow: 0 0 6px var(--iris)`
- Selector didn't match markup (`.site-title` is the `<a>`, not a parent)
- Even if it matched, glow was decorative — hierarchy already established
  by position and font-weight
- Fixed: removed the rule

#### Non-functional window control dots (image shortcodes)
- Both `image.html` and `image-grid.html` had three empty
  `<span class="window-button ...">` elements
- No CSS existed for `.window-button` — completely dead markup
- Fixed: removed from both shortcodes

#### Table header background too heavy (tables.css)
- `th` used `background-color: var(--overlay)` (#6e6a86)
- Too prominent against `--base` background
- Fixed: changed to `var(--surface)` for subtler differentiation

### Code blocks felt clunky (code.css)
- Background was `var(--base)` with `!important` — same as page, only
  the border distinguished the block from surrounding content
- Line numbers had no visual separation from code (no border, no color)
- Padding was on `.highlight` wrapper instead of `pre`, causing the
  table layout to have awkward spacing
- Fixed: background to `--surface`, line numbers `--muted` with
  `border-right`, padding moved to `pre`, removed `!important`,
  added `user-select: none` on line numbers
