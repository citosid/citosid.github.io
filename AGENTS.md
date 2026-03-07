# AGENTS.md

> AI assistant context file for abrahamsustaita.com — a Hugo-based personal technical blog with a terminal-style UI.

## Project Overview

<!-- tags: overview, purpose, stack -->

- **Framework:** Hugo (extended, ≥0.80.0)
- **URL:** <https://abrahamsustaita.com/>
- **Theme:** Custom inline terminal-style theme (Rosé Pine Moon palette)
- **Deployment:** GitHub Pages via GitHub Actions on push to `main`
- **Content:** Technical blog posts (currently a WezTerm configuration series)

## Directory Structure

<!-- tags: structure, files, directories -->

```text
.
├── config.toml              # Hugo site configuration
├── theme.toml               # Theme metadata
├── package.json             # PostCSS dependencies (autoprefixer)
├── postcss.config.js        # PostCSS config
├── index.html               # Root redirect
├── archetypes/
│   └── default.md           # New content template
├── assets/css/              # Source CSS modules (8 files)
│   ├── variables.css        # Rosé Pine Moon color tokens
│   ├── base.css             # Reset, body, font stack
│   ├── terminal.css         # Terminal window chrome, cursor
│   ├── typography.css       # Headings, links, blockquotes, lists
│   ├── posts.css            # Post card styling
│   ├── code.css             # Syntax highlighting (Chroma)
│   ├── tables.css           # Table styles
│   ├── images.css           # Image frames, grid, animations
│   └── main.css             # Imports all modules
├── content/                 # Markdown blog posts
├── layouts/
│   ├── _default/
│   │   ├── baseof.html      # Root template (CSS pipeline, terminal chrome)
│   │   ├── single.html      # Single post view
│   │   └── list.html        # Section listing view
│   ├── taxonomy/
│   │   ├── tags.html        # All tags listing
│   │   └── tag.html         # Posts for a single tag
│   └── shortcodes/
│       ├── image.html       # Terminal-framed image
│       └── image-grid.html  # Responsive image grid
├── static/                  # Static assets (images)
├── public/                  # Generated output (git-ignored)
└── .github/workflows/
    └── gh-pages.yml         # CI/CD pipeline
```

## Coding Patterns

<!-- tags: patterns, conventions, style -->

### Template Conventions

- Templates use Hugo's `block`/`define` inheritance: `baseof.html` defines `main`, child templates implement it
- Terminal prompt pattern: `me@abrahamsustaita.com:~$` followed by a command (`cat`, `ls`)
- All templates use Go template syntax with Hugo functions

### CSS Conventions

- One module per concern (8 modules total)
- All colors via CSS custom properties from `variables.css` — never use raw hex values
- Responsive: 3 breakpoints (`max-width: 768px`, default, `min-width: 1400px`)
- Hugo Pipes handles concatenation, minification, and fingerprinting — no manual CSS build step

### Content Conventions

- Flat file structure in `content/` (no subdirectories)
- Naming: `topic.sequence.subtitle.md` (e.g., `wezterm.1.projects.md`)
- Front matter: `title`, `date` required; `draft`, `tags` optional
- New posts: `hugo new content/name.md` (uses `archetypes/default.md`)

## Shortcode Reference

<!-- tags: shortcodes, images, api -->

### `image`

```text
{{< image src="file.png" alt="Description" caption="Optional" loading="lazy" >}}
```

Renders image in terminal-style frame. `src` resolves from `/img/`.

### `image-grid`

```text
{{< image-grid images="img1.png, img2.png, img3.png" >}}
```

Responsive grid with auto-resized 400px thumbnails.

## Color Palette (Rosé Pine Moon)

<!-- tags: colors, theme, design-tokens -->

| Variable | Hex | Use |
|---|---|---|
| `--base` | `#232136` | Page background |
| `--surface` | `#2a273f` | Terminal container |
| `--overlay` | `#393552` | Borders, highlights |
| `--text` | `#e0def4` | Body text |
| `--subtle` | `#908caa` | Secondary text |
| `--muted` | `#6e6a86` | Muted text |
| `--love` | `#eb6f92` | Errors, close button |
| `--gold` | `#f6c177` | Warnings, types |
| `--rose` | `#ea9a97` | Hover, inline code |
| `--pine` | `#3e8fb0` | Prompts, operators |
| `--foam` | `#9ccfd8` | Links, strings |
| `--iris` | `#c4a7e7` | Headings, keywords |

## Build and Deploy

<!-- tags: build, deploy, ci-cd -->

### Local Development

```bash
hugo server          # Dev server with live reload
hugo --minify        # Production build to public/
```

### CI/CD

GitHub Actions (`.github/workflows/gh-pages.yml`):

1. Triggered on push to `main` (PRs build but don't deploy)
2. Checkout with submodules + full git history
3. Install Hugo extended (latest)
4. `hugo --minify`
5. Deploy `public/` to GitHub Pages

### Dependencies

- **Hugo Extended** ≥0.80.0
- **Node.js** with `autoprefixer`, `postcss`, `postcss-cli` (see `package.json`)
- **GitHub Actions:** `actions/checkout@v2`, `peaceiris/actions-hugo@v2`, `peaceiris/actions-gh-pages@v3`

## Adding New CSS Modules

<!-- tags: css, howto -->

1. Create `assets/css/newmodule.css`
2. Add `@import "newmodule.css";` to `main.css`
3. Add `{{ $newmodule := resources.Get "css/newmodule.css" }}` in `baseof.html`
4. Add `$newmodule` to the `slice` in the `resources.Concat` call

## Known Issues

<!-- tags: issues, gaps -->

- `.gitmodules` is empty — theme is fully inline, not a submodule

## Detailed Documentation

For deeper information, see `.sop/summary/index.md` which indexes:

- `architecture.md` — system design and patterns
- `components.md` — template and CSS module details
- `interfaces.md` — APIs, config schema, deployment interface
- `data_models.md` — front matter, config model, design tokens
- `workflows.md` — step-by-step guides for common tasks
- `dependencies.md` — full dependency inventory
- `review_notes.md` — documentation quality findings
