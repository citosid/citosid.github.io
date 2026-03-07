# Codebase Information

## Project Overview

- **Name:** abrahamsustaita.com
- **Type:** Personal technical blog / static website
- **Framework:** Hugo (static site generator, v0.80.0+ required)
- **URL:** <https://abrahamsustaita.com/>
- **License:** MIT
- **Theme:** Terminal Blog — a custom, minimal, terminal-style theme

## Languages and File Types

| Language | Usage |
|---|---|
| HTML (Go templates) | Hugo layouts and shortcodes |
| CSS | Modular stylesheets (Rosé Pine Moon theme) |
| TOML | Hugo and theme configuration |
| Markdown | Blog content |
| Lua | Blog post content (WezTerm configuration tutorials) |
| JavaScript | PostCSS configuration |
| YAML | GitHub Actions CI/CD workflow |

## Key Directories

| Directory | Purpose |
|---|---|
| `content/` | Markdown blog posts |
| `layouts/` | Hugo templates (base, single, list, shortcodes) |
| `assets/css/` | Source CSS modules |
| `static/` | Static assets (images) |
| `public/` | Generated site output (git-ignored except `.gitkeep`) |
| `themes/` | Hugo themes directory (empty, theme is inline) |
| `data/` | Hugo data files (empty) |
| `archetypes/` | Content templates |
| `.github/workflows/` | CI/CD pipeline |
| `resources/` | Hugo-generated resources cache |

## Build and Deployment

- **Build tool:** Hugo with extended features (for CSS processing)
- **CSS processing:** PostCSS with Autoprefixer
- **Deployment:** GitHub Pages via GitHub Actions (on push to `main`)
- **Branch strategy:** `main` branch triggers deployment
