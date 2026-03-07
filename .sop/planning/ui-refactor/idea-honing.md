# Idea Honing — Terminal Theme Redesign

Requirements clarification log. One question at a time.

---

## Q1: What style direction — literal terminal or modern dev tool?

**Answer:** Hybrid. User likes interactive terminal sites like
evilprince2009.netlify.app (ShellFolio — type commands, green-on-black
CRT) and kavin.me (prompt-based portfolio with `λ :: ~ >>`), but
acknowledges they can feel weird for visitors. Also drawn to Linear's
clean, dark, minimal, content-first aesthetic. Wants a hybrid: terminal
*flavor* (monospace, prompts, dark) with Linear-style *usability*
(clean layout, clear hierarchy, no gimmicks, just works).

## Q2: OK to remove the macOS window chrome entirely?

**Answer:** Yes, fine with losing it completely. The page itself is the
terminal — no frame, no traffic-light dots, no rounded container.

## Q3: Keep per-page prompts (cat/ls) or strip them?

**Answer:** Strip them out. Terminal flavor lives in the nav only
(e.g. `~/home`, `~/tags`). Per-page prompts like
`me@abrahamsustaita.com:~$ cat post.md` are removed.

> **NOTE — reversible decision:** The per-page prompt pattern can be
> restored later by re-adding the `.command-line` div to single.html,
> list.html, tags.html, and tag.html templates. The CSS class can be
> kept commented out in terminal.css for easy revival.

## Q4: Header and footer design?

**Answer:** Approved.

- **Header:** Site title left, `~/home` and `~/tags` nav links right,
  `1px` border-bottom separator. No logo, no hamburger — links wrap on
  mobile.
- **Footer:** Terminal-flavored with subtle prompt:
  `visitor@abrahamsustaita.com:~$ echo © 2026 Abraham Sustaita`

## Q5: Post list layout?

**Answer:** Approved.

- Simple rows: title link left, date right (stacks on mobile)
- Subtle `1px` left border accent on hover (using `--iris` or `--foam`)
- No cards, no boxes, no shadows — just rows with whitespace
- Tags inline as plain text, not badges

## Q6: Subtle phosphor glow on headings?

**Answer:** Yes. Faint `text-shadow: 0 0 8px var(--iris)` on site title
and `h1` elements. Subtle enough to feel terminal-inspired without being
dramatic. No glow on body text or other elements.

## Q7: Multi-theme support — port dotfiles themes to the website?

**Answer:** Yes, explore this. User has a sophisticated theme system in
their dotfiles that generates palettes from wallpapers and applies them
across ~10 tools (neovim, tmux, kitty, ghostty, sketchybar, k9s, bat,
opencode, borders). There are 14 themes in `manifest.json`:

- enterprise-desert, prism, color-wall, headphones, catppuccin-frappe,
  catppuccin-mocha, rose-pine, crystals, ai-machine, aimachine,
  fantasy-autumn, ai-flower, aurora, tron-ares

Each theme has a consistent structure: background, foreground, 16 ANSI
colors, accent colors, border colors. The palette maps to semantic
roles (base, surface, overlay, text, subtext, accent colors).

The website could offer a theme switcher that maps these palettes to
CSS custom properties, replacing the current hardcoded Rosé Pine Moon
values in `variables.css`. This would let the website match whatever
theme the user's terminal is running.

## Q8: Theme switcher UX and persistence?

**Answer:**

- Small dropdown/selector in the header nav (a `~/theme` link that
  opens a list of available themes)
- Default theme: Rosé Pine Moon
- Persist selection in `localStorage` so it survives page reloads and
  revisits without server-side state

## Q9: How many themes to ship?

**Answer:** All of them. It's just CSS variables — no meaningful extra
work per theme. Drop duplicates, keep the newest.

Duplicates identified:
- `aimachine` is identical to `ai-machine` → drop `aimachine`

Final theme list (13 themes):

1. rose-pine (default)
2. catppuccin-frappe
3. catppuccin-mocha
4. prism
5. crystals
6. tron-ares
7. enterprise-desert
8. ai-machine
9. ai-flower
10. aurora
11. headphones
12. fantasy-autumn
13. color-wall
