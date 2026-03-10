---
title: "Teaching AI Agents Real TDD: Why Strict Rules Matter"
date: 2026-03-09
draft: false
tags:
  - ai
  - tdd
  - engineering
  - workflow
---

I've been working on a standardization SOP that restructures repository `AGENTS.md` files[^1] to enforce strict Test-Driven Development rules for autonomous coding agents. The goal is simple: make AI agents follow real TDD, not the fake version they often default to.

## The Problem

AI agents claim to follow TDD but frequently perform invalid Red steps. Here's a typical failure:

```text
FAILED test_parse_issue_success
AttributeError: method does not exist
```

The agent treats this as a valid Red step and proceeds to implement the method. This is incorrect. The test never executed the intended behavior—it failed because the structure was missing, not because the behavior was wrong.

Real TDD requires tests to fail because behavior is incorrect, not because a symbol doesn't exist.[^2]

## Why This Happens

Autonomous agents need much more explicit TDD definitions than human developers. Without strict guardrails, they frequently:

- treat missing methods as valid Red failures
- write tests without meaningful assertions
- modify tests to make implementations pass
- apply TDD to incorrect parts of the codebase (config files, scripts, test utilities)

The core issue is that agents interpret "Red-Green-Refactor" too loosely. They need normative specifications, not informal guidance.[^3]

## The Approach

I created an SOP that standardizes `AGENTS.md` files using a reference structure with required sections. The TDD rules are defined using RFC 2119 language[^3] (`MUST`, `MUST NOT`, `SHOULD`, `MAY`) to eliminate ambiguity.

The SOP introduces placeholders that agents must resolve by analyzing the repository:

```text
<production_src_paths>
<test_paths>
```

This forces agents to discover where production code lives versus where tests live. It prevents
them from incorrectly applying TDD to test files, scripts, or configuration.

## Key TDD Rules

### 1. Define Production Code Boundaries

Agents must know exactly where production code lives. The rules require automatic discovery from repository structure:

- Production code → `src/`, `app/`, `lib/`, etc.
- Tests → `tests/`, `test/`, `spec/`

### 2. Enforce Behavioral Red Failures

A valid Red test must:

- import modules successfully
- instantiate required objects
- execute the target function
- fail only on behavioral assertions

Invalid Red failures include:

- `SyntaxError`
- `ImportError`
- `ModuleNotFoundError`
- `AttributeError` caused by missing methods
- `NameError`
- fixture or test setup failures

If these occur, the test must be rewritten.

### 3. Require Placeholder Implementations

When testing a new function that doesn't exist yet, the agent must first create a placeholder implementation:

```python
def parse_issue(data):
    raise NotImplementedError
```

This ensures the test fails due to missing behavior rather than missing structure.

### 4. Require Meaningful Assertions

Tests without assertions about observable behavior are invalid:

```python
# Invalid
def test_foo():
    foo()

# Valid
def test_foo():
    result = foo()
    assert result == expected_value
```

### 5. Prevent Test Rewriting to Pass Code

A common AI failure pattern:

1. Write a test
2. Implement code
3. Test fails
4. Modify the test instead of fixing the code

The rules explicitly forbid weakening or rewriting tests to make implementations pass unless the user confirms the test is incorrect.

## Structural Safeguards

### AGENTS.md Integrity Boundary

The file includes a controlled modification boundary.[^4] Only the section titled "Detailed Documentation" may be modified automatically. All rule sections above this boundary must remain unchanged to prevent accidental alteration of agent behavior.

### Locking Normative Safety Rules

These sections must be copied verbatim and not simplified or reinterpreted:

- `TDD (Red-Green-Refactor)`
- `Step Gating`
- `AGENTS.md Integrity`

Agents sometimes weaken rules when rewriting documentation. This prevents that.[^5]

### Step Gating Model

Agents must follow a strict step workflow:[^6]

1. Stop after completing a step
2. Provide a command the user can run to verify results
3. Wait for confirmation
4. Update documentation or implementation plans
5. Commit the changes

If verification fails, the agent must diagnose and re-gate.

## What Worked Well

Using RFC 2119 language (`MUST`, `MUST NOT`) significantly improved agent compliance. The normative style removes interpretation ambiguity.

Requiring placeholder implementations solved the "missing method" Red step problem. Agents now create structure first, then test behavior.

The integrity boundary prevented agents from accidentally weakening safety rules during documentation updates.

## What Didn't Work

Initial versions didn't define production code boundaries explicitly. Agents applied TDD to test utilities and configuration files, creating circular dependencies.

Early rules didn't forbid test rewriting. Agents would modify assertions to match incorrect implementations rather than fixing the code.

## Lessons Learned

AI agents require explicit definitions of concepts human developers understand implicitly. "Write a failing test" isn't enough—you must define what constitutes a valid failure.

Normative language matters. Informal guidance gets reinterpreted. RFC 2119 keywords force agents to treat rules as specifications.

Agents need structural guardrails to prevent self-modification of safety rules. The integrity boundary is essential for autonomous workflows.

## Next Steps

The SOP currently handles TDD and step gating. Future versions should address:

- lint and type check gates
- commit message standards
- documentation update requirements
- knowledge capture workflows

The goal is a complete specification for safe autonomous development that produces production-quality code without human intervention at each step.

## References

1. [RFC 2119 - Key words for use in RFCs to Indicate Requirement Levels](https://www.ietf.org/rfc/rfc2119.txt) - Normative language specification

[^1]: AGENTS.md is a Markdown file placed at the root of a code repository that provides instructions, conventions, and context for AI coding agents. It acts as a machine-readable playbook that standardizes how autonomous agents interact with a codebase. See [AGENTS.md Standard](https://agentexperience.ax/concepts/agents-md) for more details.

[^2]: In proper Test-Driven Development, the Red phase requires that tests fail due to incorrect behavior, not missing structure. A test that fails with `ImportError`, `AttributeError`, or `NameError` hasn't actually tested the intended behavior—it failed before reaching the assertion. This distinction is critical for maintaining the integrity of the Red-Green-Refactor cycle. See [Test-Driven Development (TDD)](https://lobehub.com/skills/ericcrosson-dotfiles-test-driven-development) for verification requirements.

[^3]: RFC 2119 defines keywords like MUST, MUST NOT, SHOULD, and MAY for use in technical specifications. These keywords create unambiguous requirement levels: MUST indicates absolute requirements, SHOULD indicates strong recommendations, and MAY indicates optional features. Using this language in agent instructions eliminates interpretation ambiguity. The specification is public domain and available at [RFC 2119](https://tools.ietf.org/html/rfc2119).

[^4]: Document integrity boundaries are controlled modification zones that protect critical sections from unauthorized or accidental changes. In the context of AGENTS.md, this boundary ensures that normative rules governing agent behavior remain stable while allowing project-specific documentation to evolve. This pattern is common in regulated industries where document control maintains system integrity. See [Document Integrity](https://www.docsie.io/blog/glossary/document-integrity/) for principles.

[^5]: AI agents can inadvertently weaken safety rules when asked to "improve" or "simplify" documentation. By marking certain sections as normative and requiring verbatim copying, the SOP prevents agents from reinterpreting critical constraints. This is similar to how change control procedures in quality management systems require explicit approval for modifications to controlled documents.

[^6]: Step gating (also called quality gates or verification gates) introduces structured control points in a workflow where each phase must meet defined criteria before progression. In software development, gates typically verify that code compiles, tests pass, and quality standards are met before allowing the next step. For AI agents, step gating ensures human verification at critical points, preventing cascading errors. See [Process Gating](https://www.pixiebrix.com/glossary/process-gating) and [Software Quality Gates](https://testrigor.com/blog/software-quality-gates/) for implementation patterns.
