# Research: Theme Switcher Implementation

## Problem

Implement a multi-theme switcher for a Hugo static site with no FOUC
(flash of unstyled/wrong-themed content) and localStorage persistence.

## Approach: `data-theme` attribute + inline blocking script

Based on research from multiple Hugo theme implementations:

### Architecture

1. **CSS:** Define `:root` with default theme (rose-pine). Define each
   theme as `[data-theme="theme-name"]` selector that overrides the
   same variables.
2. **Blocking JS:** Inline a tiny script in `<head>` BEFORE stylesheets
   that reads `localStorage` and sets `data-theme` on `<html>`. This
   runs synchronously before first paint, preventing FOUC.
3. **Interactive JS:** A separate script (can be deferred) handles the
   dropdown UI and click events.

### Blocking Script (inline in head)

```javascript
(function(){
  var t = localStorage.getItem('theme');
  if (t) document.documentElement.setAttribute('data-theme', t);
})();
```

This is ~100 bytes. Must be inlined, not loaded as external file.

### Hugo Integration

Hugo Pipes can inline the blocking script. From the oostens.me approach:

```html
{{ $themeJS := resources.Get "js/theme-init.js" }}
{{ if hugo.IsServer }}
<script src="{{ $themeJS.Permalink }}"></script>
{{ else }}
{{ with $themeJS | minify }}
<script>{{ .Content | safeJS }}</script>
{{ end }}
{{ end }}
```

Place this BEFORE the CSS `<link>` tag in `baseof.html`.

### Dropdown UI

Simple `<select>` element or a custom dropdown. Given Uncodixfy rules
(keep it normal), a native `<select>` is the cleanest option — no
custom dropdown animations, no fancy styling. Just a normal form
element.

On change:
1. Set `data-theme` attribute on `<html>`
2. Save to `localStorage`

### CSS Structure

`variables.css` becomes:

```css
:root {
  /* Rose Pine Moon — default */
  --base: #232136;
  --surface: #2a273f;
  /* ... */
}

[data-theme="prism"] {
  --base: #0d0f11;
  --surface: #1a1e22;
  /* ... */
}

[data-theme="catppuccin-mocha"] {
  --base: #1e1e2e;
  --surface: #313244;
  /* ... */
}
/* ... 13 themes total */
```

No other CSS files need to change — they all reference the same
variable names.

## Sources

- [oostens.me — Hugo + CSS dark/light theme](https://oostens.me/posts/hugo--css-dark/light-theme/)
- [swyx.io — Avoiding Flash of Unthemed Code](https://swyx.io/avoid-fotc)
- [whitep4nth3r.com — Best theme toggle in JavaScript](https://whitep4nth3r.com/blog/best-light-dark-mode-theme-toggle-javascript/)

Content was rephrased for compliance with licensing restrictions.
