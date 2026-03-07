# abrahamsustaita.com

A terminal-style personal technical blog built with [Hugo](https://gohugo.io/), themed with the [Rosé Pine Moon](https://rosepinetheme.com/) color palette.

**Live site:** <https://abrahamsustaita.com/>

## Quick Start

```bash
# Install dependencies
npm install

# Run local dev server
hugo server

# Production build
hugo --minify
```

### Prerequisites

- [Hugo Extended](https://gohugo.io/installation/) ≥ 0.80.0
- [Node.js](https://nodejs.org/) (for PostCSS/Autoprefixer)

## Project Structure

```text
content/           Markdown blog posts (flat, named topic.sequence.subtitle.md)
layouts/
  _default/        Base template, single post, list views
  taxonomy/        Tag listing pages
  shortcodes/      image, image-grid shortcodes
assets/css/        8 modular CSS files (variables, base, terminal, typography, etc.)
static/            Static assets (images)
.github/workflows/ GitHub Actions CI/CD
```

## Writing a New Post

```bash
hugo new content/topic.sequence.subtitle.md
```

Edit the generated file, set `draft: false` when ready, then push to `main` to deploy.

## Deployment

Automated via GitHub Actions on push to `main`:

1. Builds with `hugo --minify`
2. Deploys `public/` to GitHub Pages

Pull requests trigger the build but not the deploy.

## License

MIT
