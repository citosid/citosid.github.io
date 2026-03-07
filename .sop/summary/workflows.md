# Workflows

## Overview

This document provides step-by-step guides for common development workflows in the abrahamsustaita.com project.

## Table of Contents

1. [Initial Setup](#initial-setup)
2. [Creating a New Blog Post](#creating-a-new-blog-post)
3. [Adding a New CSS Module](#adding-a-new-css-module)
4. [Adding a New Theme](#adding-a-new-theme)
5. [Creating a New Shortcode](#creating-a-new-shortcode)
6. [Modifying Existing Templates](#modifying-existing-templates)
7. [Updating Dependencies](#updating-dependencies)
8. [Deploying Changes](#deploying-changes)
9. [Troubleshooting Build Failures](#troubleshooting-build-failures)
10. [Testing Theme Switching](#testing-theme-switching)

## Initial Setup

### Prerequisites

- Hugo Extended ≥ 0.80.0
- Node.js (for PostCSS)
- Git

### Steps

1. **Clone the repository:**

   ```bash
   git clone https://github.com/yourusername/website.git
   cd website
   ```

2. **Install Node.js dependencies:**

   ```bash
   npm install
   ```

3. **Start development server:**

   ```bash
   hugo server
   ```

4. **Open browser:**

   Navigate to `http://localhost:1313`

### Verification

- Site loads without errors
- Theme switcher works
- All 13 themes render correctly
- Live reload works when editing files

## Creating a New Blog Post

### Steps

1. **Generate new post from archetype:**

   ```bash
   hugo new content/topic.sequence.subtitle.md
   ```

   Example:

   ```bash
   hugo new content/wezterm.3.keybindings.md
   ```

2. **Edit the generated file:**

   ```bash
   # Open in your editor
   vim content/wezterm.3.keybindings.md
   ```

3. **Update front matter:**

   ```yaml
   ---
   title: "WezTerm: Keybindings"
   date: 2026-03-07T14:31:54-05:00
   draft: false  # Change to false when ready to publish
   tags: ["wezterm", "terminal", "keybindings"]
   ---
   ```

4. **Write content in Markdown:**

   ```markdown
   ## Introduction

   This post covers WezTerm keybindings...

   ## Custom Keybindings

   Here's how to configure custom keybindings:

   ```lua
   -- WezTerm configuration
   local wezterm = require 'wezterm'
   ```
   ```

5. **Preview in browser:**

   ```bash
   hugo server -D  # -D includes drafts
   ```

   Navigate to `http://localhost:1313`

6. **Use shortcodes for images:**

   ```markdown
   {{< image src="wezterm-keys.png" alt="Keybindings diagram" caption="Custom keybindings" >}}
   ```

7. **Set draft to false when ready:**

   ```yaml
   draft: false
   ```

8. **Commit and push:**

   ```bash
   git add content/wezterm.3.keybindings.md
   git commit -m "feat: add WezTerm keybindings post"
   git push origin main
   ```

### Verification

- Post appears in listings
- Post renders correctly at its permalink
- Tags are clickable and link to tag pages
- Images display correctly
- Syntax highlighting works for code blocks

## Adding a New CSS Module

### Steps

1. **Create new CSS file:**

   ```bash
   touch assets/css/newmodule.css
   ```

2. **Define styles using design tokens:**

   ```css
   /* assets/css/newmodule.css */
   
   .new-component {
     background: var(--surface);
     color: var(--text);
     border: 1px solid var(--overlay);
   }
   
   .new-component:hover {
     background: var(--base);
     color: var(--iris);
   }
   ```

3. **Add module to baseof.html:**

   ```html
   <!-- In layouts/_default/baseof.html -->
   
   {{ $variables := resources.Get "css/variables.css" }}
   {{ $base := resources.Get "css/base.css" }}
   {{ $terminal := resources.Get "css/terminal.css" }}
   {{ $typography := resources.Get "css/typography.css" }}
   {{ $posts := resources.Get "css/posts.css" }}
   {{ $code := resources.Get "css/code.css" }}
   {{ $tables := resources.Get "css/tables.css" }}
   {{ $images := resources.Get "css/images.css" }}
   {{ $newmodule := resources.Get "css/newmodule.css" }}  <!-- Add this line -->
   
   {{ $css := slice $variables $base $terminal $typography $posts $code $tables $images $newmodule | resources.Concat "css/style.css" | minify | fingerprint }}
   ```

4. **Test with Hugo server:**

   ```bash
   hugo server
   ```

5. **Verify styles apply:**

   - Check browser DevTools
   - Verify CSS is concatenated
   - Test across all 13 themes

6. **Commit changes:**

   ```bash
   git add assets/css/newmodule.css layouts/_default/baseof.html
   git commit -m "feat: add newmodule CSS component"
   git push origin main
   ```

### Best Practices

- Use CSS custom properties for all colors
- Follow existing naming conventions
- Keep modules focused on single concerns
- Test responsive behavior at all breakpoints
- Document new classes in AGENTS.md if needed

## Adding a New Theme

### Steps

1. **Choose a color palette:**

   Select 12 colors that map to the design token system.

2. **Add theme definition to variables.css:**

   ```css
   /* assets/css/variables.css */
   
   :root[data-theme="new-theme"] {
     --base: #1a1b26;
     --surface: #24283b;
     --overlay: #414868;
     --text: #c0caf5;
     --subtle: #9aa5ce;
     --muted: #565f89;
     --love: #f7768e;
     --gold: #e0af68;
     --rose: #ff9e64;
     --pine: #7aa2f7;
     --foam: #7dcfff;
     --iris: #bb9af7;
   }
   ```

3. **Add theme option to dropdown:**

   ```html
   <!-- In layouts/_default/baseof.html -->
   
   <select id="theme-select">
     <option value="rose-pine">rose-pine</option>
     <option value="catppuccin-mocha">catppuccin-mocha</option>
     <!-- ... existing themes ... -->
     <option value="new-theme">new-theme</option>  <!-- Add this line -->
   </select>
   ```

4. **Test theme:**

   ```bash
   hugo server
   ```

   - Select new theme from dropdown
   - Verify all colors render correctly
   - Check contrast ratios for accessibility
   - Test on all page types (home, single, list, tags)

5. **Update documentation:**

   ```markdown
   <!-- In AGENTS.md -->
   
   ## Color Palette
   
   Default theme is Rosé Pine Moon. 14 themes available via dropdown switcher.
   ```

6. **Commit changes:**

   ```bash
   git add assets/css/variables.css layouts/_default/baseof.html AGENTS.md
   git commit -m "feat: add new-theme color palette"
   git push origin main
   ```

### Verification

- Theme appears in dropdown
- Theme persists after page reload
- All UI elements use correct colors
- No raw hex values in other CSS modules

## Creating a New Shortcode

### Steps

1. **Create shortcode file:**

   ```bash
   touch layouts/shortcodes/alert.html
   ```

2. **Define shortcode template:**

   ```html
   <!-- layouts/shortcodes/alert.html -->
   
   {{ $type := .Get "type" | default "info" }}
   {{ $message := .Inner }}
   
   <div class="alert alert-{{ $type }}">
     <span class="alert-icon">{{ if eq $type "warning" }}⚠️{{ else if eq $type "error" }}❌{{ else }}ℹ️{{ end }}</span>
     <span class="alert-message">{{ $message | markdownify }}</span>
   </div>
   ```

3. **Add styles to appropriate CSS module:**

   ```css
   /* assets/css/posts.css or create assets/css/alerts.css */
   
   .alert {
     padding: 1rem;
     margin: 1rem 0;
     border-left: 4px solid var(--overlay);
     background: var(--surface);
     display: flex;
     align-items: center;
     gap: 0.5rem;
   }
   
   .alert-warning {
     border-left-color: var(--gold);
   }
   
   .alert-error {
     border-left-color: var(--love);
   }
   
   .alert-icon {
     font-size: 1.5rem;
   }
   ```

4. **Test shortcode in content:**

   ```markdown
   {{< alert type="warning" >}}
   This is a warning message!
   {{< /alert >}}
   
   {{< alert type="error" >}}
   This is an error message!
   {{< /alert >}}
   
   {{< alert >}}
   This is an info message (default).
   {{< /alert >}}
   ```

5. **Document shortcode usage:**

   Update AGENTS.md with shortcode API:

   ```markdown
   ### `alert`
   
   ```text
   {{< alert type="info|warning|error" >}}
   Message content
   {{< /alert >}}
   ```
   
   Renders styled alert box with icon.
   ```

6. **Commit changes:**

   ```bash
   git add layouts/shortcodes/alert.html assets/css/posts.css AGENTS.md
   git commit -m "feat: add alert shortcode"
   git push origin main
   ```

### Best Practices

- Use `.Get` for named parameters
- Use `.Inner` for content between tags
- Use `markdownify` to process Markdown in content
- Provide sensible defaults
- Document all parameters

## Modifying Existing Templates

### Steps

1. **Identify template to modify:**

   ```bash
   ls layouts/_default/
   # baseof.html  list.html  single.html
   ```

2. **Make backup (optional):**

   ```bash
   cp layouts/_default/single.html layouts/_default/single.html.bak
   ```

3. **Edit template:**

   ```bash
   vim layouts/_default/single.html
   ```

4. **Test changes with Hugo server:**

   ```bash
   hugo server
   ```

   Hugo will automatically reload on file changes.

5. **Verify changes:**

   - Check affected pages render correctly
   - Test with different content types
   - Verify no Hugo errors in terminal

6. **Remove backup if satisfied:**

   ```bash
   rm layouts/_default/single.html.bak
   ```

7. **Commit changes:**

   ```bash
   git add layouts/_default/single.html
   git commit -m "refactor: improve single post layout"
   git push origin main
   ```

### Common Template Modifications

**Add reading time to posts:**

```html
<!-- In layouts/_default/single.html -->

<div class="post-meta">
  <time>{{ .Date.Format "2006-01-02" }}</time>
  <span>{{ .ReadingTime }} min read</span>
</div>
```

**Add table of contents:**

```html
<!-- In layouts/_default/single.html -->

{{ if .Params.toc }}
<nav class="toc">
  {{ .TableOfContents }}
</nav>
{{ end }}
```

**Add author information:**

```html
<!-- In layouts/_default/single.html -->

{{ with .Params.author }}
<div class="author">
  <span>By {{ . }}</span>
</div>
{{ end }}
```

## Updating Dependencies

### Update PostCSS Dependencies

1. **Check for updates:**

   ```bash
   npm outdated
   ```

2. **Update dependencies:**

   ```bash
   npm update
   ```

3. **Test build:**

   ```bash
   hugo --minify
   ```

4. **Commit updated package files:**

   ```bash
   git add package.json package-lock.json
   git commit -m "chore: update PostCSS dependencies"
   git push origin main
   ```

### Update Hugo

1. **Check current version:**

   ```bash
   hugo version
   ```

2. **Update via package manager:**

   ```bash
   # macOS (Homebrew)
   brew upgrade hugo
   
   # Linux (snap)
   sudo snap refresh hugo
   
   # Windows (Chocolatey)
   choco upgrade hugo-extended
   ```

3. **Verify extended version:**

   ```bash
   hugo version
   # Should show "extended"
   ```

4. **Test build:**

   ```bash
   hugo server
   ```

### Update GitHub Actions

GitHub Actions auto-update to latest minor versions (e.g., `v4` → `v4.x`).

To update major versions:

1. **Edit workflow file:**

   ```bash
   vim .github/workflows/gh-pages.yml
   ```

2. **Update action versions:**

   ```yaml
   - uses: actions/checkout@v5  # Update from v4
   - uses: peaceiris/actions-hugo@v3  # Update from v2
   ```

3. **Test workflow:**

   Push to a test branch and verify workflow succeeds.

4. **Commit changes:**

   ```bash
   git add .github/workflows/gh-pages.yml
   git commit -m "chore: update GitHub Actions to latest versions"
   git push origin main
   ```

## Deploying Changes

### Automatic Deployment (Default)

1. **Commit changes:**

   ```bash
   git add .
   git commit -m "feat: add new feature"
   ```

2. **Push to main:**

   ```bash
   git push origin main
   ```

3. **Monitor deployment:**

   - Go to GitHub repository
   - Click "Actions" tab
   - Watch workflow progress
   - Verify "Deploy" step succeeds

4. **Verify live site:**

   Navigate to `https://abrahamsustaita.com/` and verify changes.

### Manual Deployment (If Needed)

1. **Build site locally:**

   ```bash
   hugo --minify
   ```

2. **Verify public/ directory:**

   ```bash
   ls public/
   ```

3. **Deploy manually (if needed):**

   ```bash
   # This is handled by GitHub Actions normally
   # Manual deployment not recommended
   ```

### Rollback Deployment

1. **Identify last good commit:**

   ```bash
   git log --oneline
   ```

2. **Revert to last good commit:**

   ```bash
   git revert <commit-hash>
   git push origin main
   ```

3. **Or reset to last good commit (destructive):**

   ```bash
   git reset --hard <commit-hash>
   git push --force origin main
   ```

## Troubleshooting Build Failures

### Hugo Build Fails Locally

1. **Check Hugo version:**

   ```bash
   hugo version
   # Ensure extended version ≥ 0.80.0
   ```

2. **Check for template errors:**

   ```bash
   hugo server
   # Look for error messages in terminal
   ```

3. **Common errors:**

   - **Missing closing tag:** Check template syntax
   - **Invalid front matter:** Validate YAML syntax
   - **Missing resource:** Verify file paths in templates

4. **Validate front matter:**

   ```bash
   # Check for YAML syntax errors
   cat content/post.md | head -n 10
   ```

5. **Clear Hugo cache:**

   ```bash
   hugo --gc
   rm -rf public/ resources/
   hugo server
   ```

### GitHub Actions Build Fails

1. **Check workflow logs:**

   - Go to GitHub repository
   - Click "Actions" tab
   - Click failed workflow
   - Expand failed step

2. **Common failures:**

   - **npm install fails:** Check package.json syntax
   - **Hugo build fails:** Check template syntax
   - **Deploy fails:** Check GitHub token permissions

3. **Test locally:**

   ```bash
   npm install
   hugo --minify
   ```

4. **Fix and push:**

   ```bash
   git add .
   git commit -m "fix: resolve build failure"
   git push origin main
   ```

### PostCSS Errors

1. **Check PostCSS config:**

   ```bash
   cat postcss.config.js
   ```

2. **Verify dependencies installed:**

   ```bash
   npm list autoprefixer postcss postcss-cli
   ```

3. **Reinstall dependencies:**

   ```bash
   rm -rf node_modules package-lock.json
   npm install
   ```

4. **Test build:**

   ```bash
   hugo --minify
   ```

## Testing Theme Switching

### Manual Testing

1. **Start Hugo server:**

   ```bash
   hugo server
   ```

2. **Open browser DevTools:**

   - Press F12
   - Go to "Application" tab
   - Expand "Local Storage"
   - Select site URL

3. **Test each theme:**

   - Select theme from dropdown
   - Verify colors update immediately
   - Check localStorage shows correct theme
   - Reload page and verify theme persists

4. **Test all page types:**

   - Homepage
   - Single post
   - List page
   - Tags page
   - Individual tag page

5. **Test responsive behavior:**

   - Resize browser window
   - Test at mobile width (< 768px)
   - Test at desktop width
   - Test at wide width (> 1400px)

### Automated Testing (Future)

Consider adding:

- Visual regression tests (Percy, Chromatic)
- Accessibility tests (axe-core)
- Performance tests (Lighthouse CI)

### Verification Checklist

- [ ] All 13 themes render correctly
- [ ] Theme persists after page reload
- [ ] Theme persists across page navigation
- [ ] No FOUC (Flash of Unstyled Content)
- [ ] Dropdown shows correct selected theme
- [ ] localStorage updates on theme change
- [ ] All colors use CSS custom properties
- [ ] No console errors in browser DevTools

## Common Workflows Summary

| Task | Command | Time |
|------|---------|------|
| Start dev server | `hugo server` | Instant |
| Create new post | `hugo new content/name.md` | Instant |
| Build production | `hugo --minify` | ~1 second |
| Install dependencies | `npm install` | ~10 seconds |
| Update dependencies | `npm update` | ~10 seconds |
| Deploy to production | `git push origin main` | ~2 minutes |
| Add new CSS module | Edit files + update baseof.html | ~5 minutes |
| Add new theme | Edit variables.css + baseof.html | ~10 minutes |
| Create new shortcode | Create file + add styles | ~15 minutes |

## Workflow Best Practices

1. **Always test locally before pushing:**

   ```bash
   hugo server
   # Verify changes in browser
   ```

2. **Use conventional commits:**

   ```bash
   git commit -m "feat: add new feature"
   git commit -m "fix: resolve bug"
   git commit -m "docs: update documentation"
   git commit -m "chore: update dependencies"
   ```

3. **Commit directly to main:**

   No feature branches needed for this single-contributor project.

4. **Document discoveries:**

   Update `.sop/summary/` files when learning new patterns.

5. **Use design tokens:**

   Never use raw hex colors in CSS modules.

6. **Test all themes:**

   Verify changes work across all 13 themes.

7. **Keep commits atomic:**

   One logical change per commit.

8. **Write descriptive commit messages:**

   Explain what and why, not how.
