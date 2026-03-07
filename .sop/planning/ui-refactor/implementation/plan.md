# Implementation Plan — Terminal Theme Redesign

## Progress Checklist

- [ ] Step 1: Theme CSS variables (all 13 themes in variables.css)
- [ ] Step 2: Theme init script (blocking, no FOUC)
- [ ] Step 3: Layout overhaul (baseof.html, terminal.css, base.css)
- [ ] Step 4: Template updates (single, list, tags, tag)
- [ ] Step 5: Typography and post styling
- [ ] Step 6: Theme switcher UI (dropdown + JS)
- [ ] Step 7: Verify and document

---

## Step 1: Theme CSS Variables

**Objective:** Replace the single `:root` palette in `variables.css`
with the default rose-pine theme plus 12 `[data-theme]` override blocks.

**Guidance:**

- Keep `:root` as rose-pine-moon (current values, unchanged)
- Add one `[data-theme="name"]` block per additional theme using the
  hex values from the detailed design palette table
- Same 12 variable names in every block: `--base`, `--surface`,
  `--overlay`, `--text`, `--subtle`, `--muted`, `--love`, `--gold`,
  `--rose`, `--pine`, `--foam`, `--iris`

**Demo:** Open dev tools, run
`document.documentElement.setAttribute('data-theme', 'prism')` — the
entire page recolors instantly.

---

## Step 2: Theme Init Script

**Objective:** Create `assets/js/theme-init.js` and inline it in
`baseof.html` `<head>` before the CSS link to prevent FOUC.

**Guidance:**

- Script reads `localStorage.getItem('theme')` and sets `data-theme`
  on `document.documentElement`
- Wrap in try/catch so localStorage errors don't block rendering
- In `baseof.html`, use Hugo Pipes to inline the minified script:
  external `<script src>` in dev, inlined `<script>` in production
- Place BEFORE the CSS `<link>` tag

**Integrates with:** Step 1 (themes must exist in CSS for this to work)

**Demo:** Set `localStorage.setItem('theme', 'tron-ares')` in console,
reload page — tron-ares renders immediately with no flash.

---

## Step 3: Layout Overhaul

**Objective:** Replace the macOS window chrome in `baseof.html` with
the new header/footer structure. Update `terminal.css` and `base.css`.

**Guidance:**

- `baseof.html`: Remove the `.window-header` div with traffic-light
  buttons. Add `<header class="site-header">` with site title and nav.
  Add `<footer class="site-footer">` with the prompt-style copyright.
  Add the theme switcher `<select>` in the nav (wired up in Step 6).
- `base.css`: Remove body padding. Body is the terminal now.
- `terminal.css`: Remove all `.window-header`, `.window-button`,
  `.close`, `.minimize`, `.maximize` styles. Add `.site-header`,
  `.site-nav`, `.site-title`, `.site-footer` styles. Keep `#terminal`
  as a max-width centered flex column container.

**Integrates with:** Steps 1-2 (theme variables and init script already
in baseof.html)

**Demo:** `hugo server` — site renders with header nav, footer, no
window chrome. Navigation links work.

---

## Step 4: Template Updates

**Objective:** Remove per-page command-line prompts from all child
templates.

**Guidance:**

- `single.html`: Remove the `.command-line` div. Keep the article
  markup.
- `list.html`: Remove the `.command-line` div. Update post listing
  markup to use the new row layout (title left, date right).
- `tags.html`: Remove the `.command-line` div.
- `tag.html`: Remove the `.command-line` div.

**Integrates with:** Step 3 (layout must be in place)

**Demo:** Navigate to all page types — posts, list, tags, single tag.
No command prompts visible. Content renders cleanly.

---

## Step 5: Typography and Post Styling

**Objective:** Add phosphor glow to headings and update post list
styling.

**Guidance:**

- `typography.css`: Add `text-shadow: 0 0 8px var(--iris)` to `h1`
  elements. Add the same glow to `.site-title a`.
- `posts.css`: Style post rows as flex containers (title left, date
  right). Add `border-left: 2px solid transparent` with transition,
  changing to `var(--foam)` on hover. Add left padding on hover for
  subtle indent. Tags displayed inline as plain text after the date.

**Integrates with:** Steps 3-4 (layout and templates must be in place)

**Demo:** Homepage shows post list with hover effect. Post titles glow
faintly. Responsive at 768px (date stacks below title).

---

## Step 6: Theme Switcher UI

**Objective:** Create `assets/js/theme-switcher.js` and wire up the
`<select>` dropdown in the header.

**Guidance:**

- The `<select>` element is already in `baseof.html` from Step 3
  (with `id="theme-select"`)
- `theme-switcher.js`: On DOMContentLoaded, set the select value to
  match current theme from localStorage. On change, set `data-theme`
  on `<html>` and save to localStorage.
- Load this script with `defer` at end of `<head>` or before `</body>`
- Use Hugo Pipes: `resources.Get "js/theme-switcher.js" | minify | fingerprint`

**Integrates with:** Steps 1-3 (themes in CSS, init script, select in
HTML)

**Demo:** Click the theme dropdown, select "tron-ares" — page recolors
instantly. Reload — tron-ares persists. Select "rose-pine" — back to
default.

---

## Step 7: Verify and Document

**Objective:** Final verification and documentation updates.

**Guidance:**

- Test all 13 themes render correctly
- Test FOUC prevention (select non-default theme, hard reload)
- Test responsive at 768px and 1400px
- Test localStorage persistence across page navigations
- Update `.sop/summary/` files with discoveries
- Commit with conventional commit message

**Demo:** Full site walkthrough — homepage, single post, tags page,
single tag page — all working with theme switching and no visual
regressions.
