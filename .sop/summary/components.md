# Components

## Layout Templates

### `layouts/_default/baseof.html`

The root template. Responsibilities:

- HTML document structure with lang attribute
- Meta tags (charset, viewport)
- Inline blocking theme-init.js script (prevents FOUC)
- CSS pipeline: collects all 8 CSS modules via Hugo Pipes, concatenates, minifies, and fingerprints
- Deferred theme-switcher.js script
- Favicon link
- Site header with title, nav links (~/home, ~/tags), and theme dropdown
- Terminal content container (flexbox column)
- Site footer with terminal prompt style
- Defines the `main` block for child templates

### `layouts/_default/single.html`

Renders individual blog posts. Displays:

- Post title (h1 with phosphor glow)
- Post metadata: date, reading time, and tags
- Full post content

### `layouts/_default/list.html`

Renders section listing pages. Displays:

- Post list in row layout (title left, date/tags right)
- Left border accent on hover with subtle indent
- Responsive: stacks on mobile

### `layouts/taxonomy/tags.html`

Renders all tags listing. Displays:

- "All Tags" heading
- Tag list with post counts

### `layouts/taxonomy/tag.html`

Renders posts for a single tag. Displays:

- "Tag: {name}" heading
- Post list in row layout

## JavaScript

### `assets/js/theme-init.js`

Blocking script inlined in `<head>` before CSS. Reads `localStorage.getItem('theme')` and sets `data-theme` attribute on `<html>` to prevent FOUC. Wrapped in try/catch for localStorage errors.

### `assets/js/theme-switcher.js`

Deferred script loaded at end of `<head>`. Handles theme dropdown:

- Sets select value to current theme from localStorage
- On change: updates `data-theme` attribute and saves to localStorage
- Empty value removes theme (returns to default)

## Shortcodes

### `image`

Renders a single image in a terminal-style frame.

Parameters:

| Param | Required | Default | Description |
|---|---|---|---|
| `src` | Yes | — | Image filename (looked up in `/img/`) |
| `alt` | Yes | — | Alt text, also shown in frame title bar |
| `caption` | No | — | Caption displayed below image as terminal echo |
| `loading` | No | `lazy` | Loading strategy (`lazy` or `eager`) |

### `image-grid`

Renders multiple images in a responsive grid layout.

Parameters:

| Param | Required | Description |
|---|---|---|
| `images` | Yes | Comma-separated list of image filenames |

Images are auto-resized to 400px width thumbnails via Hugo image processing.

## CSS Modules

| Module | Responsibility |
|---|---|
| `variables.css` | 13 theme palettes as CSS custom properties (`:root` + 12 `[data-theme]` blocks) |
| `base.css` | Reset, body defaults, font stack, selection styles |
| `terminal.css` | Terminal container (flexbox), header, nav, footer, theme select |
| `typography.css` | Headings with phosphor glow, links, blockquotes, lists |
| `posts.css` | Post row layout, hover effects, tag styles |
| `code.css` | Syntax highlighting (Chroma/Monokai), inline code |
| `tables.css` | Table borders and header styling |
| `images.css` | Image frames, grid layout, hover effects, load animation |

## Content

Blog posts are Markdown files in `content/` with TOML front matter:

```yaml
---
title: "Post Title"
date: 2024-12-25
draft: false
tags: []
---
```

Current content is a multi-part WezTerm configuration tutorial series.

## Static Assets

- `static/wezterm.png` — WezTerm screenshot used in blog posts
- Fonts: FiraCode Bold and Regular (woff format, in `public/fonts/`)
