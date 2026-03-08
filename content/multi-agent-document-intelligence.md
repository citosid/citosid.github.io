---
title: "Building a Multi-Agent Document Intelligence System with Kiro CLI"
date: 2026-03-08T13:00:00-04:00
draft: false
tags: ["ai", "multi-agent", "kiro"]
---

I needed a way to ask questions about a pile of documents — PDFs, Word files, images — and get a
cited answer back. Not a summary of one file, but a synthesis across dozens of them. The kind of
thing where you'd normally spend an afternoon reading, cross-referencing, and taking notes.

The problem is that LLMs choke when you try to stuff 50 documents into a single context window.
So I built a multi-agent system where specialized workers each handle one file, and an
orchestrator stitches the results together. Here's how it works and why the architecture decisions matter.

## The Core Problem: Context Overflow

Every LLM has a context window — a fixed budget of tokens it can process at once. Load a 200-page
PDF and you've already consumed a significant chunk. Try loading ten of them and you're either
truncating content or hitting hard limits.

The naive approach is to concatenate everything and hope the model figures it out. That fails in
predictable ways: the model loses track of which information came from which source, earlier
documents get "forgotten" as the window fills, and you can't scale beyond a handful of files.

The solution is to never put more than one document in a single agent's context.

## The Architecture

The system uses a hierarchical pipeline where each agent has a specific job and a restricted set of tools:

```text
User Query
   │
   ▼
Orchestrator (glob + subagents only)
   │
   ├── File Worker (1 per file, MCP document-loader)
   │        └── Returns JSON summary
   │
   ├── Image Worker (1 per image, MCP document-loader)
   │        └── Returns JSON analysis
   │
   └── Writer (fs_write, only when asked)
         └── Requires user approval
```

The orchestrator can discover files and spawn workers, but it physically can't read file
contents — it doesn't have `fs_read` in its tool list. Workers can read files but can't spawn
other agents. The writer can modify files but requires explicit user approval for every operation.

This isn't just a prompt instruction like "please don't read files directly." The tools are
restricted at the configuration level. The orchestrator literally doesn't have the capability to
read a file, the same way a process without filesystem permissions can't open a file regardless
of what code it runs.

## Why Tool Restriction Matters More Than Prompt Instructions

Early in the process, I tried a different approach: a single SOP (Standard Operating Procedure)
that told the default agent to delegate file reading to subagents. The SOP said "You MUST NOT use
fs_read to read file contents." The agent ignored it and read the files directly every time.

This makes sense. The model sees `fs_read` in its available tools, sees that the task involves
reading files, and takes the shortest path. Prompt instructions are suggestions. Tool
restrictions are constraints. When you need guaranteed behavior, restrict the tools.

This is the same principle behind the security concept of least privilege — don't give a process
permissions it doesn't need, because you can't rely on the process choosing not to use them.

## The Agent Configuration

Each agent is a JSON file that defines its name, description, system prompt, and — critically —
which tools it can access. Here's the orchestrator:

```json
{
  "name": "doc-intel",
  "tools": ["use_subagent", "glob"],
  "allowedTools": ["use_subagent", "glob"],
  "toolsSettings": {
    "subagent": {
      "availableAgents": [
        "doc-intel-file-worker",
        "doc-intel-image-worker",
        "doc-intel-writer"
      ],
      "trustedAgents": ["doc-intel-file-worker", "doc-intel-image-worker"]
    }
  }
}
```

Notice that `doc-intel-writer` is in `availableAgents` but not in `trustedAgents`. That means the
orchestrator can invoke it, but every invocation requires the user to approve it. Read operations
are trusted and run automatically. Write operations need a human in the loop.

The file worker is even more locked down:

```json
{
  "name": "doc-intel-file-worker",
  "mcpServers": {
    "document-loader": {
      "command": "uvx",
      "args": ["awslabs.document-loader-mcp-server"]
    }
  },
  "tools": ["@document-loader"],
  "allowedTools": ["@document-loader"],
  "includeMcpJson": false
}
```

It can only use the MCP document-loader. It can't read arbitrary files, can't run shell commands,
can't access the internet. It loads one document, summarizes it into a JSON envelope, and returns.
The `includeMcpJson: false` flag means it doesn't inherit the global MCP server configuration —
it only gets the document-loader.

## Context Isolation by Design

Each subagent runs with its own isolated context window. When the orchestrator spawns four file
workers in parallel, each one starts fresh with only:

- The file path it needs to process
- The user's query for relevance scoring
- Its system prompt

No cross-contamination between files. No accumulated context from previous workers. This is what
makes the system scale — processing 100 files uses the same amount of context per worker as
processing 5.

The workers return compressed JSON summaries capped at 500 tokens each. The orchestrator never
sees the raw document text. It works with structured envelopes:

```json
{
  "file_path": "/docs/report.pdf",
  "file_type": "pdf",
  "summary": "Q4 revenue was $12.3M, up 15% YoY...",
  "entities": [{ "name": "Q4 2025", "type": "period" }],
  "key_information": ["Revenue increased 15% year-over-year"],
  "relevance_score": 0.95,
  "images_detected": [
    { "image_id": "chart_p3", "location": "page 3", "estimated_relevance": 0.8 }
  ]
}
```

This is the same pattern used in distributed systems: services communicate through well-defined
contracts, not by sharing internal state.

## Batching Around Platform Limits

Kiro CLI supports up to 4 parallel subagents. With 50 files to process, the orchestrator batches
them into groups of 4, waits for each batch to complete, then spawns the next. It's not as fast
as spawning all 50 at once, but it works within the platform's constraints and still provides
significant parallelism.

The orchestrator also handles failures gracefully: if a batch fails, it retries once, then skips
those files and notes them as errors in the final answer. The pipeline doesn't stop because one
PDF is corrupted.

## Image Analysis: Selective, Not Exhaustive

File workers detect embedded images and estimate their relevance to the query. The orchestrator
reviews these estimates and only spawns image analysis workers for images that are likely to
contain useful information — diagrams, charts, data tables. Decorative images, logos, and headers
get skipped.

This matters because image analysis is slow and expensive. A Word document with 30 embedded
images doesn't need all 30 analyzed to answer a question about budget figures. The system routes
intelligently instead of processing everything.

## Lessons from the First Real Test

The first test was against real work documents — a meeting preparation file, two venue
specification documents full of images, and a project timeline. Several things happened:

1. **A subagent returned XML instead of JSON.** The worker prompt said "return only JSON" but one
   model decided to wrap it in XML tags. The fix was adding explicit "NEVER return XML, NEVER use XML
   tags" to the prompt. Defensive prompting works.

2. **A batch timed out after 5+ minutes.** Large DOCX files with many high-resolution images take time
   to process through the MCP document-loader. The orchestrator's retry logic handled this, but
   it highlighted the need for reasonable timeout expectations.

3. **The orchestrator tried to read files directly.** When I first tried running this as a SOP from
   the default agent (which has all tools), the model ignored the delegation instructions and just
   used `fs_read`. This is what led to the tool restriction approach — the dedicated `doc-intel` agent
   that physically cannot read files.

Each of these failures improved the system. That's the value of testing with real documents instead
of synthetic examples.

## What About Other Tools?

This architecture isn't unique to Kiro CLI. The principles — context isolation, tool restriction,
structured communication, hierarchical delegation — apply anywhere you're building multi-agent
systems. The implementation details differ:

- **GitHub Copilot** has evolved into a multi-agent development platform with specialized agents for
  different workflows, but these are primarily fixed-purpose agents — not user-configurable for
  arbitrary workflows like document analysis. Custom agents
  [are now supported](https://onlyutkarsh.com/posts/2025/github-copilot-custom-agents/) in VS Code,
  allowing developers to define specialized AI assistants with specific prompts and tool access.

- **Roo Code** takes a cloud-based approach with 5 role-based agents ([Explainer, Planner, Coder,
  PR Reviewer, PR Fixer](https://docs.roocode.com/roo-code-cloud/cloud-agents)). Each runs in an
  isolated cloud environment, giving strong context isolation but requiring cloud infrastructure.
  Locally, Roo Code uses "Custom Modes" — specialized AI personas with scoped tool permissions —
  rather than a subagent delegation model.

- **Cline** supports [parallel subagents](https://cline-efdc8260.mintlify.app/features/subagents)
  that are read-only by design — they can explore the codebase but can't edit files or execute
  commands. Each subagent gets its own context window. The restriction model is similar in spirit
  to what we built, though the configuration is less declarative.

- **OpenCode** offers configurable agents with tool restrictions through its JSON-based
  configuration system, providing flexibility similar to Kiro's approach. Agents can have
  permissions configured to control tool access.

The key differentiator in Kiro's approach is the declarative JSON configuration with explicit
`availableAgents`, `trustedAgents`, and per-agent tool lists. You define the security model in
configuration, not in prompts.

## What the Architecture Review Found

After building the system, I ran a formal architecture review — reading every file, comparing
against documented multi-agent patterns, and rating the implementation. The results were
instructive.

The strongest aspect was context safety (8/10). Single-file workers with isolated context,
structured JSON envelopes, and MCP isolation via `includeMcpJson: false` form a solid foundation.
The tool-level enforcement of separation of concerns — where the orchestrator physically cannot
read files — was validated as the right approach.

The weakest aspect was operational reliability (5/10). The system works, but it has no
observability. There's no structured logging of which files were processed, which failed, how
long each batch took, or how many tokens were consumed. When something goes wrong, you're
debugging blind.

Several concrete risks emerged:

The 500-token summary budget is enforced only by prompt instruction. There's no validation that
workers actually comply. With 100+ files, oversized summaries could silently accumulate and
overflow the orchestrator's context. The fix is straightforward — add a length check in the
orchestrator's aggregation step.

The writer agent has `fs_read` access it doesn't need. It receives content to write via the
subagent query context, so arbitrary file reading is unnecessary scope. Removing it tightens the
permission model.

The image relevance threshold (0.6) exists in an SOP document that the orchestrator agent doesn't
load. The orchestrator's prompt says "skip decorative images" without a numeric threshold,
leaving the filtering to model interpretation. Adding an explicit number makes it deterministic.

There's also no caching. If you ask about the same file in two different queries, it gets re-
processed both times. A summary cache keyed by file path and modification time would eliminate
redundant MCP calls.

These are the kinds of issues you only find by auditing the implementation against the design —
not by testing happy paths.

## The Improvement Roadmap

Based on the review, the next iteration focuses on:

1. Summary length verification in the orchestrator
2. Explicit numeric thresholds for image routing
3. Removing unnecessary `fs_read` from the writer
4. Batch progress summaries for observability
5. Aligning documentation with the actual 4-agent implementation
6. Eventually: summary caching and large document chunking

## The Takeaway

If you're building multi-agent systems for document analysis — or any task where context overflow
is a risk — the architecture matters more than the prompts:

1. **Restrict tools, don't just instruct.** If an agent shouldn't read files, remove `fs_read`
   from its tool list. Don't rely on "please don't read files" in the prompt.

2. **One document per worker.** Context isolation isn't just about preventing overflow — it
   ensures each document gets the model's full attention.

3. **Structured communication.** JSON envelopes with fixed schemas prevent raw text from leaking
   between agents and keep the orchestrator's context predictable.

4. **Trust boundaries.** Read operations can be trusted. Write operations should require human
   approval. Not every subagent needs the same permission level.

5. **Test with real documents.** Synthetic tests won't surface the XML response issue, the
   timeout on image-heavy DOCX files, or the model's preference for taking shortcuts when tools are
   available.

6. **Audit your own implementation.** Run a formal review comparing your code against documented
   patterns. The gaps between design intent and actual behavior are where the real improvements hide.

The system processes real work documents now — meeting preparations, venue specifications,
project timelines — and produces cited answers that would've taken an afternoon of manual
reading. The architecture is 4 JSON files and a handful of SOPs. The complexity is in the design
decisions, not the implementation.

## References

1. [Kiro CLI Documentation](https://kiro.dev/docs/cli/) - Agent configuration and subagent system
2. [Model Context Protocol](https://modelcontextprotocol.io/) - Open standard for AI tool integration
3. [AWS Labs Document Loader MCP Server](https://awslabs.github.io/mcp/servers/document-loader-mcp-server) - MCP
   server for document loading
4. [AWS Open Source: Introducing Strands Agent SOPs](https://aws.amazon.com/blogs/opensource/introducing-strands-agent-sops-natural-language-workflows-for-ai-agents/) - Agent SOP methodology
5. [Microsoft ISE: Patterns for Building a Scalable Multi-Agent
   System](https://devblogs.microsoft.com/ise/multi-agent-systems-at-scale/) - Orchestration patterns at scale
6. [Roo Code Cloud Agents](https://docs.roocode.com/roo-code-cloud/cloud-agents) - Cloud-based agent team architecture
7. [Cline Subagents](https://cline-efdc8260.mintlify.app/features/subagents) - Read-only parallel research agents
