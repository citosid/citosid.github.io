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
