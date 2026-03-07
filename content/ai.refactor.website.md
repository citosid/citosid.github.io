---
title: "Refactoring My Website with AI"
date: 2026-03-07T12:00:00-05:00
draft: false
tags: ["ai", "hugo", "css", "workflow"]
---

I rebuilt the visual design of this website using AI as a pair programmer. Not a one-shot "generate me a website" prompt — an iterative back-and-forth where I directed the design decisions and the AI handled the implementation. Here's what happened, what worked, and what didn't.

## The Problem

This site started as a terminal-themed Hugo blog with a macOS window chrome aesthetic — traffic light dots, a rounded container floating on a dark background, per-page command prompts like `me@abrahamsustaita.com:~$ cat post.md`. It looked like a screenshot of a terminal rather than feeling like one.

I wanted to keep the terminal flavor (monospace, dark, prompts in the nav) but drop the gimmicks and make it feel more like Linear or Raycast — clean, content-first, no decorative noise.

I also had 13 color themes in my dotfiles that I apply across neovim, tmux, kitty, and other tools. I wanted the website to support all of them.

## The Approach

I broke the work into phases using a planning document before writing any code:

1. **Requirements gathering** — 9 questions answered one at a time to nail down the design direction
2. **Research** — how to map my kitty theme configs to CSS variables, how to prevent flash of unstyled content (FOUC) with localStorage
3. **Detailed design** — full architecture, component specs, all 13 theme palettes mapped out
4. **Implementation plan** — 7 incremental steps, each producing something demoable

Then I executed the plan step by step, committing after each one.

## Using AI in the Workflow

The AI acted as an implementer, not a designer. I made every design decision — the AI translated those decisions into code.

The workflow looked like this:

1. I described what I wanted in plain language
2. The AI read the existing codebase to understand the current state
3. It proposed changes and I approved or redirected
4. It wrote the code, I reviewed the output in the browser
5. When something looked wrong, I said so and it iterated

For example, when I said "the code blocks seem clunky," the AI audited the CSS and identified specific problems: the background was the same color as the page, line numbers had no visual separation, padding was on the wrong element. It proposed fixes, I approved them, and we iterated from there.

The key insight: **AI is good at identifying what's wrong with existing UI and proposing targeted fixes. It's less good at generating good UI from scratch.** When I let it implement a full design from a spec, the results were solid. When it had to make aesthetic judgment calls on its own, it needed correction.

## Technical Details

### Theme System

The 13 themes are pure CSS. Each theme is a `[data-theme]` attribute selector that overrides 12 CSS custom properties:

```css
:root[data-theme="tron-ares"] {
  --base: #0d0e11;
  --surface: #1a1d22;
  --overlay: #4a6a8a;
  --text: #e0e8f0;
  /* ... */
}
```

A blocking inline script in `<head>` reads `localStorage` and sets the attribute before the browser paints — no FOUC. The theme switcher is a native `<select>` element. No custom dropdown, no JavaScript framework, no animation.

### Layout Overhaul

The macOS window chrome was replaced with a simple header/footer structure. The page itself is the terminal — no wrapper frame. Navigation uses terminal-flavored links (`~/home`, `~/tags`) with a `1px` border separator.

### Code Block Refactor

This was the most iterative part. The original code blocks used Hugo's table-based line numbers (`lineNos = "table"`), which wraps code in a two-column `<table>`. Styling highlights across the table gap was painful — the highlight background only covered each `<td>` independently, leaving an unhighlighted seam between the line numbers and code.

We switched to `lineNos = "inline"`, which renders line numbers as inline `<span>` elements next to the code. Much simpler DOM, much easier to style.

Getting full-width highlight stripes on inline spans was tricky. `display: inline-block` with `width: 100%` collapsed all lines into one. The solution was a negative margin/padding trick:

```css
.chroma .line.hl {
  background-color: var(--overlay);
  margin: 0 -1rem;
  padding: 0 1rem;
}
```

This extends the background to the edges of the `<pre>` padding without affecting the text layout.

### Uncodixfy Audit

I ran the site through a UI audit focused on removing default AI-generated aesthetic patterns — what the industry calls ["AI slop"](https://techbytes.app/posts/escape-ai-slop-frontend-design-guide/): the generic look you get when AI gravitates toward the statistical median of its training data (purple gradients, oversized rounded corners, glass effects, decorative animations). The site scored well since the terminal concept was a real design decision, but we found and fixed:

- A dead `text-shadow` glow rule that didn't match any markup
- Non-functional window control dot `<span>` elements in image shortcodes (no CSS existed for them — pure dead markup)
- Table headers using `--overlay` as a background color (too heavy, switched to `--surface`)

## What Worked Well

- **Planning before coding** — the 9-question requirements phase and detailed design doc meant the AI had clear constraints. It didn't have to guess what I wanted.
- **Incremental commits** — each step was independently verifiable. When something broke, the blast radius was small.
- **AI reading existing code** — the AI was good at auditing CSS and finding inconsistencies (dead selectors, wrong color tokens, mismatched specificity).
- **Iterative feedback** — saying "the code blocks seem clunky" was enough for the AI to identify specific problems and propose fixes. I didn't need to diagnose the CSS myself.

## What Didn't Work

- **Full-width highlights on inline spans** — we went through three approaches before landing on the negative margin trick. The AI's first instinct (`display: inline-block; width: 100%`) broke the layout completely. It took real-time browser feedback to converge on a working solution.
- **Table-based line numbers** — the AI initially tried to fix the table layout with `tr:has(.hl)` to paint highlight backgrounds on full rows. This highlighted the entire code block instead of individual lines. Switching to inline line numbers was the right call, but we should have done it first instead of trying to fix the table approach.
- **Specificity issues with themes** — the initial theme implementation used `:root[data-theme]` but the fallback `:root` block had equal specificity, causing themes to not override correctly. Required a second pass to fix.

## Lessons Learned

1. **AI pair programming works best with tight feedback loops.** The most productive pattern was: describe the problem → AI proposes a fix → check the browser → redirect if needed. Long autonomous runs produced more rework.

2. **Design decisions should stay with the human.** The AI is an excellent implementer but a mediocre designer. Every time I let it make an aesthetic choice, I had to correct it. Every time I gave it a clear spec, the output was good.

3. **Audit existing code before adding new code.** The Uncodixfy audit found dead CSS, dead markup, and wrong color tokens that had been there since the original build. Cleaning those up first made the new work cleaner.

4. **Hugo's line number table layout is a trap.** If you need to style highlighted lines in Hugo code blocks, use `lineNos = "inline"` from the start. The table layout makes cross-column styling nearly impossible without hacks.

5. **Watch out for accidental AI aesthetics in your own choices.** After reading about AI slop's signature purple gradients, I realized my headings were all `--iris` (purple) across every theme. It was a real design token from Rosé Pine, not an AI default — but it still read as "generic AI site" to fresh eyes. Switching headings to `--gold` gave the site a warmer, more distinctive feel and broke the association.

## Next Steps

- Theme the syntax highlighting colors per palette (currently hardcoded to Rosé Pine Moon)
- Add a `dotfiles theme generate` command that auto-generates the CSS block for new themes
- Write more posts using this AI workflow and refine the process

## References

- [Escape AI Slop Frontend Design Guide](https://techbytes.app/posts/escape-ai-slop-frontend-design-guide/) — on distributional convergence and the AI aesthetic monoculture
- [Breaking the AI Slop Aesthetic](https://paddo.dev/blog/claude-code-plugins-frontend-design/) — why LLMs default to the median of Tailwind tutorials
- [Frontend Aesthetics Prompt](https://www.josecasanova.com/prompts/frontend-aesthetics/) — a system prompt designed to fight generic AI-generated UI
- [Stop AI from generating purple slop](https://www.unslop.design/) — a tool for turning design vision into AI-proof specs
- [Where does that purple gradient come from?](https://www.jackpearce.co.uk/notes/purple-gradient-ai-aesthetics/) — tracing the origins of the default AI color palette
