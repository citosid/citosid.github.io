# Uncodixfy

## Overview

This SOP teaches you how to build UI that looks human-designed instead of AI-generated. Codex UI is the default AI aesthetic: soft gradients, floating panels, eyebrow labels, decorative copy, hero sections in dashboards, oversized rounded corners, transform animations, dramatic shadows, and layouts that try too hard to look premium. Your job is to recognize these patterns, avoid them completely, and build interfaces that feel like Linear, Raycast, Stripe, or GitHub—not like another generic AI dashboard.

## Parameters

- **user_input** (required): Description of the UI to build or modify

## Steps

### 1. Discover Project Colors

Read the project's existing color definitions before writing any CSS.

**Constraints:**
- You MUST search for existing color variables, tokens, or palette files in the project
- You MUST use the project's existing colors if they exist
- You MUST NOT invent random color combinations
- If no project palette exists, you SHOULD draw inspiration from one of the predefined palettes in the Color Reference section
- Colors MUST stay calm and muted—never blue-leaning unless the project already uses blue

### 2. Plan the UI

Review the request and identify every default AI UI pattern you would normally reach for.

**Constraints:**
- You MUST internally list every "Codex-style" choice you would make by default
- You MUST NOT implement any of those choices
- You MUST pick the harder, cleaner option for each decision
- You SHOULD replicate figma/designer-made component patterns, not invent your own
- A landing page MUST have proper full sections; a dashboard MUST have proper layout with sidebar and content areas—do NOT invent new layouts

### 3. Build with Normal Components

Implement the UI using the Keep It Normal standard below.

**Constraints:**
- Sidebars: You MUST use 240-260px fixed width, solid background, simple border-right. You MUST NOT use floating shells or rounded outer corners
- Headers: You MUST use simple text with h1/h2 hierarchy. You MUST NOT use eyebrow labels, uppercase labels, or gradient text
- Sections: You MUST use standard 20-30px padding. You MUST NOT use hero blocks inside dashboards or decorative copy
- Navigation: You MUST use simple links with subtle hover states. You MUST NOT use transform animations or non-functional badges
- Buttons: You MUST use solid fills or simple borders with 8-10px radius max. You MUST NOT use pill shapes or gradient backgrounds
- Cards: You MUST use 8-12px radius max with subtle borders. You MUST NOT use shadows over 8px blur or floating effects
- Forms: You MUST use standard inputs with clear labels above fields. You MUST NOT use floating labels
- Inputs: You MUST use solid borders with simple focus ring. You MUST NOT use animated underlines or morphing shapes
- Modals: You MUST use centered overlay with simple backdrop. You MUST NOT use slide-in animations
- Dropdowns: You MUST use simple list with subtle shadow. You MUST NOT use fancy animations
- Tables: You MUST use clean rows with simple borders and subtle hover. You MUST NOT use zebra stripes unless needed
- Tabs: You MUST use simple underline or border indicator. You MUST NOT use pill backgrounds or sliding animations
- Typography: You MUST use system fonts or simple sans-serif with 14-16px body. You MUST NOT mix serif/sans combos
- Spacing: You MUST use consistent scale (4/8/12/16/24/32px). You MUST NOT use random gaps or excessive padding
- Borders: You MUST use 1px solid with subtle colors. You MUST NOT use thick decorative or gradient borders
- Shadows: You MUST use subtle shadows (0 2px 8px rgba(0,0,0,0.1) max). You MUST NOT use dramatic drop shadows or colored shadows
- Transitions: You MUST use 100-200ms ease with simple opacity/color changes. You MUST NOT use bouncy animations or transform effects
- Containers: You MUST use max-width 1200-1400px centered with standard padding
- Panels: You MUST use simple background differentiation with subtle borders. You MUST NOT use floating detached panels or glass effects
- Toolbars: You MUST use standard height 48-56px with clear actions. You MUST NOT add decorative elements

### 4. Verify Against Banned Patterns

Review the output against every banned pattern.

**Constraints:**
- You MUST NOT use border radii in the 20-32px range
- You MUST NOT use floating detached sidebars with rounded outer shells
- You MUST NOT place canvas charts in glass cards without product reason
- You MUST NOT use glows instead of hierarchy
- You MUST NOT use "premium dark mode" (blue-black gradients + cyan accents)
- You MUST NOT use eyebrow labels (uppercase with letter-spacing)
- You MUST NOT use hero sections inside dashboards
- You MUST NOT use decorative copy as page headers
- You MUST NOT use section notes explaining what the UI does
- You MUST NOT use transform animations on hover (e.g., translateX)
- You MUST NOT use dramatic box shadows (e.g., 0 24px 60px)
- You MUST NOT use muted labels with uppercase + letter-spacing
- You MUST NOT use pipeline bars with gradient fills
- You MUST NOT use KPI card grids as the default dashboard layout
- You MUST NOT use nav badges showing counts or "Live" status
- You MUST NOT use brand marks with gradient backgrounds
- You MUST NOT use `<small>` as headers
- You MUST NOT use rounded `<span>` elements
- You MUST NOT use any of these HTML patterns:

```html
<!-- BANNED: headline block with eyebrow -->
<div class="headline">
  <small>Team Command</small>
  <h2>One place to track what matters today.</h2>
  <p>decorative copy</p>
</div>

<!-- BANNED: team-note card -->
<div class="team-note">
  <small>Focus</small>
  <strong>decorative guidance text</strong>
</div>
```

## Color Reference

When the project has no existing palette, select from these:

### Dark Palettes

| Palette | Background | Surface | Primary | Secondary | Accent | Text |
|---------|-----------|---------|---------|-----------|--------|------|
| Midnight Canvas | `#0a0e27` | `#151b3d` | `#6c8eff` | `#a78bfa` | `#f472b6` | `#e2e8f0` |
| Obsidian Depth | `#0f0f0f` | `#1a1a1a` | `#00d4aa` | `#00a3cc` | `#ff6b9d` | `#f5f5f5` |
| Slate Noir | `#0f172a` | `#1e293b` | `#38bdf8` | `#818cf8` | `#fb923c` | `#f1f5f9` |
| Carbon Elegance | `#121212` | `#1e1e1e` | `#bb86fc` | `#03dac6` | `#cf6679` | `#e1e1e1` |
| Deep Ocean | `#001e3c` | `#0a2744` | `#4fc3f7` | `#29b6f6` | `#ffa726` | `#eceff1` |
| Charcoal Studio | `#1c1c1e` | `#2c2c2e` | `#0a84ff` | `#5e5ce6` | `#ff375f` | `#f2f2f7` |
| Graphite Pro | `#18181b` | `#27272a` | `#a855f7` | `#ec4899` | `#14b8a6` | `#fafafa` |
| Void Space | `#0d1117` | `#161b22` | `#58a6ff` | `#79c0ff` | `#f78166` | `#c9d1d9` |
| Twilight Mist | `#1a1625` | `#2d2438` | `#9d7cd8` | `#7aa2f7` | `#ff9e64` | `#dcd7e8` |
| Onyx Matrix | `#0e0e10` | `#1c1c21` | `#00ff9f` | `#00e0ff` | `#ff0080` | `#f0f0f0` |

### Light Palettes

| Palette | Background | Surface | Primary | Secondary | Accent | Text |
|---------|-----------|---------|---------|-----------|--------|------|
| Cloud Canvas | `#fafafa` | `#ffffff` | `#2563eb` | `#7c3aed` | `#dc2626` | `#0f172a` |
| Pearl Minimal | `#f8f9fa` | `#ffffff` | `#0066cc` | `#6610f2` | `#ff6b35` | `#212529` |
| Ivory Studio | `#f5f5f4` | `#fafaf9` | `#0891b2` | `#06b6d4` | `#f59e0b` | `#1c1917` |
| Linen Soft | `#fef7f0` | `#fffbf5` | `#d97706` | `#ea580c` | `#0284c7` | `#292524` |
| Porcelain Clean | `#f9fafb` | `#ffffff` | `#4f46e5` | `#8b5cf6` | `#ec4899` | `#111827` |
| Cream Elegance | `#fefce8` | `#fefce8` | `#65a30d` | `#84cc16` | `#f97316` | `#365314` |
| Arctic Breeze | `#f0f9ff` | `#f8fafc` | `#0284c7` | `#0ea5e9` | `#f43f5e` | `#0c4a6e` |
| Alabaster Pure | `#fcfcfc` | `#ffffff` | `#1d4ed8` | `#2563eb` | `#dc2626` | `#1e293b` |
| Sand Warm | `#faf8f5` | `#ffffff` | `#b45309` | `#d97706` | `#059669` | `#451a03` |
| Frost Bright | `#f1f5f9` | `#f8fafc` | `#0f766e` | `#14b8a6` | `#e11d48` | `#0f172a` |
