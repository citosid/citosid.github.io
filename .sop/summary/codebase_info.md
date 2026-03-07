# Codebase Information

## Overview

**Project Name:** abrahamsustaita.com  
**Type:** Static site generator (Hugo-based technical blog)  
**URL:** <https://abrahamsustaita.com/>  
**License:** MIT

## Technology Stack

### Core Framework

- **Hugo Extended** v0.157.0+ (minimum v0.80.0)
  - Static site generator with Go templating
  - Extended version required for SCSS/PostCSS processing

### Frontend Technologies

- **HTML5** - Go template syntax (9 template files)
- **CSS3** - Modular CSS with custom properties (9 CSS modules)
- **JavaScript** - Vanilla JS for theme management (2 JS files)

### Build Tools

- **PostCSS** v8.4.49 - CSS processing
- **Autoprefixer** v10.4.20 - CSS vendor prefixing
- **postcss-cli** v11.0.0 - PostCSS command-line interface

### Deployment

- **GitHub Actions** - CI/CD pipeline
- **GitHub Pages** - Static hosting
- **Node.js** v20 - Build environment

## Project Structure

```text
abrahamsustaita.com/
├── archetypes/          # Content templates
│   └── default.md       # New post archetype
├── assets/              # Source assets (processed by Hugo Pipes)
│   ├── css/             # 9 modular CSS files
│   │   ├── variables.css    # 13 theme palettes
│   │   ├── base.css         # Reset & base styles
│   │   ├── terminal.css     # Terminal UI components
│   │   ├── typography.css   # Text styles
│   │   ├── posts.css        # Post-specific styles
│   │   ├── code.css         # Syntax highlighting
│   │   ├── tables.css       # Table styles
│   │   ├── images.css       # Image & grid styles
│   │   └── main.css         # Import orchestrator
│   └── js/              # JavaScript modules
│       ├── theme-init.js    # Blocking FOUC prevention
│       └── theme-switcher.js # Theme dropdown handler
├── content/             # Markdown blog posts (flat structure)
│   ├── wezterm.1.projects.md
│   ├── wezterm.2.ui.md
│   ├── ai.refactor.website.md
│   └── ai.writing.blog-posts.md
├── layouts/             # Hugo templates
│   ├── _default/        # Base templates
│   │   ├── baseof.html      # Root template (CSS/JS pipeline)
│   │   ├── single.html      # Single post view
│   │   └── list.html        # Section listing
│   ├── taxonomy/        # Tag pages
│   │   ├── tags.html        # All tags listing
│   │   └── tag.html         # Single tag posts
│   ├── shortcodes/      # Reusable content components
│   │   ├── image.html       # Terminal-framed image
│   │   └── image-grid.html  # Responsive image grid
│   └── index.html       # Homepage template
├── static/              # Static assets (copied as-is)
│   └── wezterm.png      # Blog post images
├── .github/workflows/   # CI/CD configuration
│   └── gh-pages.yml     # GitHub Pages deployment
├── config.toml          # Hugo site configuration
├── theme.toml           # Theme metadata
├── package.json         # Node.js dependencies
├── postcss.config.js    # PostCSS configuration
└── public/              # Generated site (git-ignored)
```

## File Counts by Type

- **Templates (HTML):** 9 files
- **Stylesheets (CSS):** 9 files
- **Scripts (JS):** 3 files (2 source + 1 config)
- **Content (Markdown):** 4 blog posts + 1 archetype
- **Configuration:** 4 files (config.toml, theme.toml, package.json, postcss.config.js)

## Key Architectural Patterns

### Template Inheritance

- `baseof.html` defines the root structure with `{{ block "main" . }}` placeholders
- Child templates (`single.html`, `list.html`) implement blocks using `{{ define "main" }}`
- Shortcodes provide reusable content components

### CSS Architecture

- **Modular Design:** 8 concern-separated CSS modules
- **Design Tokens:** All colors use CSS custom properties from `variables.css`
- **Theme System:** 13 theme palettes via `data-theme` attribute
- **Hugo Pipes:** Concatenation, minification, and fingerprinting handled by Hugo

### Content Organization

- **Flat Structure:** All posts in `content/` root (no subdirectories)
- **Naming Convention:** `topic.sequence.subtitle.md` (e.g., `wezterm.1.projects.md`)
- **Front Matter:** `title`, `date` required; `draft`, `tags` optional

### Build Pipeline

1. PostCSS processes CSS (Autoprefixer)
2. Hugo concatenates CSS modules via `resources.Concat`
3. Hugo minifies and fingerprints assets
4. Static site generated to `public/`
5. GitHub Actions deploys to GitHub Pages on push to `main`

## Design System

### Terminal-Style UI

- **Prompt Pattern:** `me@abrahamsustaita.com:~$` followed by commands
  - `cat` for single posts
  - `ls` for list pages
- **Color Palette:** Rosé Pine Moon (default) + 12 additional themes
- **Typography:** Monospace fonts for terminal aesthetic

### Responsive Breakpoints

- Mobile: `max-width: 768px`
- Desktop: default
- Wide: `min-width: 1400px`

## Development Workflow

### Commands

```bash
npm install          # Install PostCSS dependencies
hugo server          # Dev server with live reload
hugo --minify        # Production build
hugo new content/name.md  # Create new post
```

### Git Workflow

- Direct commits to `main` branch (single contributor)
- No feature branches unless explicitly requested
- Automated deployment on push to `main`

## External Dependencies

### Runtime Dependencies

None (static site)

### Build Dependencies

- `autoprefixer` ^10.4.20
- `postcss` ^8.4.49
- `postcss-cli` ^11.0.0

### CI/CD Dependencies

- `actions/checkout@v4`
- `peaceiris/actions-hugo@v2`
- `actions/setup-node@v4`
- `peaceiris/actions-gh-pages@v3`

## Configuration Files

### config.toml

- Base URL, language, title
- Content type configuration
- Syntax highlighting settings (Monokai style)
- Site parameters (description, Git info, favicon)

### theme.toml

- Theme metadata (name, license, description)
- Author information
- Feature tags and minimum Hugo version

### package.json

- PostCSS toolchain dependencies
- No scripts defined (Hugo handles build)

### postcss.config.js

- Autoprefixer plugin configuration

## Language Support

### Supported Languages

- **HTML/Go Templates** - Full support (Hugo templating)
- **CSS** - Full support (PostCSS processing)
- **JavaScript** - Full support (vanilla JS)
- **Markdown** - Full support (content format)
- **TOML** - Full support (configuration)

### Unsupported Languages

None identified in this codebase.

## Integration Points

### GitHub Actions

- Triggered on push to `main` or pull requests
- Builds with Hugo Extended + Node.js 20
- Deploys to GitHub Pages (main branch only)

### Hugo Pipes

- CSS concatenation and minification
- JavaScript minification
- Asset fingerprinting for cache busting
- Subresource Integrity (SRI) hashes

### Browser APIs

- `localStorage` - Theme persistence
- `document.documentElement.setAttribute` - Theme switching
- Event listeners - Theme dropdown interaction

## Documentation Locations

- **User Documentation:** `README.md`
- **Agent Documentation:** `AGENTS.md`
- **Codebase Summary:** `.sop/summary/` (this directory)
- **Planning Artifacts:** `.sop/planning/`
