---
title: "Using AI to Write Blog Posts About Using AI"
date: 2026-03-07
draft: true
tags: ["ai", "writing", "workflow", "meta"]
---

I just published a [blog post about refactoring this website with AI](/ai.refactor.website/). The post itself was also written with AI. And then proof-read with AI. Here's how that worked — the meta layer of using AI to document AI-assisted work.

## The Problem

I'd spent a session refactoring the site's UI with an AI pair programmer. The work was spread across 20+ commits, planning documents, design specs, and a running log of discoveries. Turning all of that into a coherent blog post meant synthesizing context from multiple sources, maintaining a consistent narrative, and not forgetting the interesting parts buried in the middle of the session.

Writing it manually would mean re-reading every commit, every planning doc, and every conversation turn to reconstruct the story. That's exactly the kind of synthesis task AI is good at.

## The Workflow

I used three SOPs (Standard Operating Procedures) — structured prompts that define inputs, steps, and constraints for the AI to follow.

### SOP 1: Write the Draft

The writing SOP takes two inputs: a `type` (`draft` or `publish`) and a `path` for the markdown file. It follows a defined procedure:

1. Check if the file exists
2. If new, create it with `draft: true` frontmatter
3. If an existing draft, update incrementally
4. Apply confidentiality rules (strip company names, internal URLs, API keys)
5. If publishing, polish the narrative and set `draft: false`

I pointed the AI at the planning documents in `.sop/planning/ui-refactor/` and the discovery log in `.sop/summary/ui-tightening.md`. It read the rough idea, the 9-question requirements session, the detailed design, the implementation plan, and the running list of issues found and fixed.

From that, it produced a first draft covering the full arc: problem, approach, AI workflow, technical details, what worked, what didn't, and lessons learned.

### SOP 2: Iterate on the Draft

The draft wasn't done after one pass. The iteration went like this:

1. AI generated the draft — I read it
2. I noticed it used the term "Codex UI" to describe the generic AI aesthetic. I asked: is that an accepted industry term? The AI researched it and found the real term is "AI slop" — backed by multiple articles on distributional convergence. It updated the post with the correct terminology and added references.
3. After changing heading colors from purple to gold (an actual code change to the site), I told the AI to update the draft. It added a new lesson learned about accidental AI aesthetics.
4. After changing inline code colors, same thing — the draft stayed in sync with the actual work.

Each iteration was a small commit. The draft evolved alongside the code it was describing.

### SOP 3: Proof-Read

The proof-reading SOP is more rigorous. It has seven steps:

1. Load the draft and establish a baseline
2. Verify every factual claim — with references if provided, via web search if not
3. Review technical accuracy of code samples and explanations
4. Check structure and narrative flow
5. Review clarity and style
6. Apply all fixes inline
7. Produce a change summary listing every modification

The proof-read caught a real error: the post referenced `lineNumbersInTable = true` and `lineNumbersInTable = false` as Hugo configuration keys. Those were the old Hugo syntax. The current Hugo configuration uses `lineNos = "table"` and `lineNos = "inline"`. The AI corrected all three occurrences in the post.

That's the kind of catch that matters. I wrote the post based on what we'd discussed during the coding session, where we used the old config key names. The proof-read SOP verified the claims against Hugo's actual documentation and fixed them.

## What Worked Well

- **SOPs as structured prompts.** Giving the AI a defined procedure with explicit constraints produced more consistent output than open-ended "write me a blog post" prompts. The confidentiality rules, the incremental update logic, the fact verification steps — these all prevented common failure modes.

- **Draft-alongside-code pattern.** Creating the draft while the work was still in progress meant the AI had full context. It could read the planning docs, the commit history, and the discovery logs. Waiting until after the work is done means reconstructing context from memory.

- **Fact verification caught real errors.** The Hugo config key correction wasn't something I would have caught in a manual proof-read. I knew what I meant, so I would have read past it. The AI verified against the source.

- **Small iterative commits.** The draft went through 5 commits before publishing: initial draft, terminology fix, heading color lesson, proof-read corrections, and the publish commit. Each one was reviewable.

## What Didn't Work

- **The AI doesn't know your voice.** The draft was technically accurate and well-structured, but it read like technical documentation, not like my other posts. The WezTerm posts are more conversational — "it will... not do nothing." The AI-generated draft was more formal. I had to accept that trade-off or rewrite sections manually.

- **Confidentiality rules were unnecessary here.** The SOP includes steps to strip company names, internal URLs, and API keys. For a personal blog about a personal project, none of that applied. The rules didn't hurt, but they added cognitive overhead to the SOP for no benefit in this context.

- **The proof-read SOP is heavy for short posts.** Seven steps including web-search fact verification is appropriate for a technical tutorial with version numbers and API references. For a narrative post about a workflow, most of the verification steps found nothing to verify. The overhead was low (the AI just moved through the steps quickly), but it's worth noting.

## The Meta Observation

There's something recursive about this. I used AI to refactor a website, then used AI to write about it, then used AI to proof-read what AI wrote, and now I'm using AI to write about that process. At some point you have to ask: where does the human contribution start and end?

For me, the answer is clear: **the human contributes judgment.** I decided what the site should look like. I decided the code blocks were clunky. I decided "Codex UI" was the wrong term. I decided the headings shouldn't be purple. I decided the draft needed a lesson about accidental AI aesthetics. I decided when to publish.

The AI contributed execution: reading files, writing CSS, synthesizing documents into prose, verifying facts against sources. It's fast and thorough at those tasks. But it never once said "this heading color is going to make your site look like AI slop." That observation came from me reading an article the AI found.

The best workflow isn't "AI writes, human approves." It's "human directs, AI executes, human redirects." The redirecting is where the value lives.

## Lessons Learned

1. **SOPs beat open-ended prompts for repeatable tasks.** A structured procedure with constraints produces more consistent results than "write me a blog post about X." The constraints prevent the AI from making choices you'd have to undo.

2. **Write the draft while the work is fresh.** Don't wait until the project is done. Create the draft alongside the code so the AI has access to planning docs, commit history, and discovery logs while they're still in context.

3. **Fact verification is the highest-value proof-reading step.** The AI caught a real technical error that I would have missed. For technical blog posts, automated fact-checking against official documentation is worth the extra pass.

4. **Accept the voice trade-off or budget time for rewrites.** AI-generated prose is competent but generic. If your blog has a distinctive voice, you'll need to either rewrite sections or accept a more neutral tone for AI-assisted posts.

5. **The recursive meta-layer is fine.** Using AI to write about AI isn't a gimmick if the content is genuinely useful. The workflow documented here is something other engineers can reuse. The tool used to document it doesn't diminish the documentation.
