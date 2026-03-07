# Components

## Layout Templates

### `layouts/_default/baseof.html`

The root template. Responsibilities:

- HTML document structure with lang attribute
- Meta tags (charset, viewport)
- CSS pipeline: collects all 8 CSS modules via Hugo Pipes, concatenates, minifies, and fingerprints
- Favicon link
- Terminal window chrome (header with close/minimize/maximize buttons)
- Defines the `main` block for child templates

### `layouts/_default/single.html`

Renders individual blog posts. Displays:

- Terminal prompt with `cat filename.md` command
- Post title, date, reading time, and tags
- Full post content

### `layouts/_default/list.html`

Renders section listing pages. Displays:

- Terminal prompt with `ls section/` command
- Iterates over `.Pages` showing post title, date, reading time, and tags

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
| `variables.css` | Rosé Pine Moon color palette as CSS custom properties |
| `base.css` | Reset, body defaults, font stack, selection styles |
| `terminal.css` | Terminal container, window chrome, cursor animation |
| `typography.css` | Headings, links, blockquotes, lists |
| `posts.css` | Post card styling, titles, meta |
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
