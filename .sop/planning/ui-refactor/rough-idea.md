# Rough Idea — Terminal Theme Redesign

Redesign the abrahamsustaita.com Hugo blog to keep the terminal
philosophy but abandon the current macOS-window-chrome style (traffic
light buttons, rounded container floating on a background). The site
should feel like you are *inside* a terminal, not looking at a
screenshot of one.

## Current Pain Points

- The macOS window chrome (close/minimize/maximize dots) feels gimmicky
- The single rounded container floating on a dark background reads as
  "terminal screenshot" rather than "terminal experience"
- The design lacks a proper navigation header and footer

## Constraints (from AGENTS.md and docs/uncodixfy.md)

- All colors MUST use CSS custom properties from the existing Rosé Pine
  Moon palette in `variables.css`
- No raw hex values
- No oversized rounded corners, no glassmorphism, no gradients, no
  dramatic shadows, no pill shapes, no hero sections
- Keep it normal: simple borders, subtle hover states, functional layout
- Monospace font throughout (already in place)
- Hugo Pipes CSS pipeline must be preserved
- Commit directly to `main`
