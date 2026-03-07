# AGENTS.md — abrahamsustaita.com

> The key words "MUST", "MUST NOT", "SHALL", "SHOULD", and "MAY" in
> this document are to be interpreted as described in RFC 2119.

## Rule Priority

Knowledge Capture and Git Workflow rules take precedence over all other
instructions in this file. When in doubt, the agent MUST stop and ask.

## AGENTS.md Integrity

The section titled "Detailed Documentation" marks the only region that
MAY be modified automatically. All content above that heading MUST
remain unchanged. Automated tools and prompts (including codebase
summarizers) MUST NOT modify any section above "Detailed Documentation"
because uncontrolled edits to rules and constraints can silently change
agent behavior. Any automated changes to this file MUST be limited to
the "Detailed Documentation" section and MUST preserve all existing
rules, structure, and formatting above it.

## Knowledge Capture

When the agent discovers something during development, the agent MUST
document it in the relevant `.sop/summary/` file before the step is
considered complete.

## Project Overview

- **Framework:** Hugo (extended, ≥0.80.0)
- **URL:** <https://abrahamsustaita.com/>
- **Theme:** Custom inline terminal-style theme (Rosé Pine Moon palette)
- **Deployment:** GitHub Pages via GitHub Actions on push to `main`
- **Content:** Technical blog posts (currently a WezTerm configuration series)

## Commands

| Command | Purpose |
| --- | --- |
| `npm install` | Install PostCSS dependencies |
| `hugo server` | Dev server with live reload |
| `hugo --minify` | Production build to `public/` |
| `hugo new content/name.md` | Create new post from archetype |

## Code Style

### Template Conventions

- Templates MUST use Hugo's `block`/`define` inheritance: `baseof.html`
  defines `main`, child templates implement it.
- Terminal prompt pattern: `me@abrahamsustaita.com:~$` followed by a
  command (`cat` for single posts, `ls` for list pages).
- All templates MUST use Go template syntax with Hugo functions.

### CSS Conventions

- One module per concern (9 modules total).
- All colors MUST use CSS custom properties from `variables.css`. The
  agent MUST NOT use raw hex color values because they bypass the
  design token system and break theme consistency.
- Responsive: 3 breakpoints (`max-width: 768px`, default,
  `min-width: 1400px`).
- Hugo Pipes handles concatenation, minification, and fingerprinting —
  no manual CSS build step.

### Content Conventions

- Content MUST use a flat file structure in `content/` (no subdirectories).
- Naming: `topic.sequence.subtitle.md` (e.g., `wezterm.1.projects.md`).
- Front matter: `title`, `date` MUST be present; `draft`, `tags` MAY
  be included.
- New posts: `hugo new content/name.md` (uses `archetypes/default.md`).

## Git Workflow

The agent MUST commit directly to `main`. The agent MUST NOT create
feature branches because this is a personal project with a single
contributor, and branches add unnecessary overhead. If the user
explicitly requests a branch, the agent MAY create one.

Commit messages SHOULD follow conventional commit format:

- `feat:` for new features
- `fix:` for bug fixes
- `docs:` for documentation changes
- `style:` for formatting changes
- `refactor:` for code refactoring
- `chore:` for maintenance tasks

## Shortcode Reference

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

## Color Palette

Default theme is Rosé Pine Moon. 13 themes available via dropdown switcher.

| Variable | Default (rose-pine) | Use |
| --- | --- | --- |
| `--base` | `#232136` | Page background |
| `--surface` | `#2a273f` | Elevated backgrounds |
| `--overlay` | `#6e6a86` | Borders, highlights |
| `--text` | `#e0def4` | Body text |
| `--subtle` | `#908caa` | Secondary text |
| `--muted` | `#6e6a86` | Muted text |
| `--love` | `#eb6f92` | Errors, red accent |
| `--gold` | `#f6c177` | Warnings, types |
| `--rose` | `#ea9a97` | Hover, inline code |
| `--pine` | `#3e8fb0` | Prompts, operators |
| `--foam` | `#9ccfd8` | Links, strings |
| `--iris` | `#c4a7e7` | Headings, keywords, phosphor glow |

## Adding New CSS Modules

1. Create `assets/css/newmodule.css`
2. Add `@import "newmodule.css";` to `main.css`
3. Add `{{ $newmodule := resources.Get "css/newmodule.css" }}` in
   `baseof.html`
4. Add `$newmodule` to the `slice` in the `resources.Concat` call

## Key Paths

| Path | Purpose |
| --- | --- |
| `config.toml` | Hugo site configuration |
| `theme.toml` | Theme metadata |
| `package.json` | PostCSS dependencies |
| `postcss.config.js` | PostCSS config (Autoprefixer) |
| `archetypes/default.md` | New content template |
| `assets/css/` | Source CSS modules (9 files) |
| `assets/css/variables.css` | 13 theme palettes as CSS custom properties |
| `assets/css/main.css` | CSS module imports |
| `assets/js/theme-init.js` | Blocking theme init script (prevents FOUC) |
| `assets/js/theme-switcher.js` | Theme dropdown UI handler |
| `content/` | Markdown blog posts |
| `layouts/_default/baseof.html` | Root template (JS, CSS pipeline, header, footer) |
| `layouts/_default/single.html` | Single post view |
| `layouts/_default/list.html` | Section listing view |
| `layouts/taxonomy/tags.html` | All tags listing |
| `layouts/taxonomy/tag.html` | Posts for a single tag |
| `layouts/shortcodes/image.html` | Terminal-framed image shortcode |
| `layouts/shortcodes/image-grid.html` | Responsive image grid shortcode |
| `static/` | Static assets (images) |
| `.github/workflows/gh-pages.yml` | CI/CD pipeline |
| `.sop/summary/` | Codebase documentation |

## Agent Compliance Checklist

Before declaring a task complete, the agent MUST verify:

- [ ] No feature branches were created (committed directly to `main`)
- [ ] No raw hex color values were introduced (CSS custom properties only)
- [ ] Any discoveries are documented in `.sop/summary/`
- [ ] A conventional commit was created

## Detailed Documentation

For architecture, data models, workflows, and component details,
see `.sop/summary/index.md` which indexes:

- `codebase_info.md` — project overview, structure, and technology stack
- `architecture.md` — system design, patterns, and architectural decisions
- `components.md` — template, CSS, and JavaScript component details
- `interfaces.md` — APIs, config schemas, shortcodes, and deployment interfaces
- `data_models.md` — front matter, config models, design tokens, and state management
- `workflows.md` — step-by-step guides for common development tasks
- `dependencies.md` — comprehensive dependency inventory and management
- `review_notes.md` — documentation quality assessment and improvement recommendations

### Using the Documentation

**For AI Assistants:**

Start with `.sop/summary/index.md` as your primary context file. It contains:

- Quick navigation strategy for finding relevant information
- Detailed summaries of each documentation file
- Common question patterns mapped to documentation files
- Documentation relationships and cross-references

The index is designed to help you locate specific information without loading all documentation files into context simultaneously.

**Quick Reference:**

- **"How do I...?"** → `workflows.md`
- **"What is...?"** → `codebase_info.md` or `components.md`
- **"Where is...?"** → `codebase_info.md`
- **"Why does...?"** → `architecture.md`
- **"How does...work?"** → `architecture.md` or `components.md`

### Documentation Coverage

- **Total Documentation:** 8 files + 1 index (~25,000 words)
- **Coverage:** 90% (see `review_notes.md` for gaps)
- **Last Updated:** 2026-03-07
- **Format:** Markdown with Mermaid diagrams (no ASCII art)
