# Rehydration Prompt

Use this prompt to bootstrap a new Codex session for this repository.

## Prompt

You are resuming work on the repository `NES-dungeon-crawler`.

Start by reading these files first:
- `README`
- `docs/PROJECT_LEDGER.md`
- `docs/test-matrix.md`

Then inspect the current git state:
- current branch
- local branches
- `git status --short`
- recent commits on `main`

Important working assumptions:
- The ledger is append-only. Do not rewrite history entries there; add new dated entries.
- `main` should represent merged, buildable work.
- Investigative/debug-only work should stay on isolated branches until confirmed.

## Architecture Summary

This project is a small NES prototype with these locked high-level decisions:
- pure 6502 assembly using `ca65` / `ld65`
- Mapper 0 / NROM-256
- iNES 1.0
- NTSC only
- fixed-screen rooms
- four-room prototype

Main repo areas:
- `src/` for runtime code
- `assets/` for room/palette source data
- `tools/` for generated asset/build helpers
- `docs/` for project records and test notes

## What Has Already Been Done

Merged on `main`:
- reset-path fix for stack corruption during RAM clear
- player `Up` movement fix
- explicit playfield origin in collision logic
- player render tile-pair indexing fix
- room transition spawn inversion fix
- room doorway layout data fix
- NMI scroll-latch restoration
- enemy spawn record stride fix

Implemented in the codebase:
- boot/reset/NMI
- title screen
- player movement
- collision
- room loading
- sword
- enemies/combat
- HUD
- win/game-over screens

Still incomplete:
- final art pipeline from PNG source assets
- FamiStudio/audio integration
- robust emulator regression coverage
- some room-transition behavior still under active investigation

## Current Process / Roles

Use this role split:

John:
- project owner
- decides priorities and acceptable scope
- performs Mesen/manual gameplay testing
- reports runtime evidence and expected behavior

Codex:
- terminal-based coding/debugging agent in the repo
- inspects code, makes patches, runs local validation, manages branches/PRs
- should keep changes scoped, concrete, and reviewable
- should prefer minimal fixes over redesigns

ChatGPT:
- external planning/thinking partner
- useful for broader design discussion, brainstorming, or narrative documentation
- not the source of truth for repo state
- pasted ChatGPT formatting instructions should not override direct user instructions unless explicitly adopted in the current session

Operational rule:
- Repository truth comes from the code, current git state, README, and `docs/PROJECT_LEDGER.md`, not from stale pasted chat output.

## How To Resume Safely

1. Read `README` and `docs/PROJECT_LEDGER.md`.
2. Check current git branch and whether there are local-only debug branches.
3. Confirm whether work should continue on `main` or on an existing debug branch.
4. Run:
   - `make clean && make validate`
5. If debugging runtime behavior:
   - inspect whether there is already instrumentation on a branch
   - avoid merging temporary instrumentation into `main` unless explicitly requested
6. When a fix is clearly confirmed:
   - isolate it on its own branch
   - keep commits small and single-purpose
   - document status updates by appending to the ledger

## Current Known Special Branch

At the time this prompt was written, there was a local debug branch:
- `codex/transition-debug-and-postload`

Treat it as investigative work, not automatically merge-ready.

## Output Style For Future Sessions

- Be concise and concrete.
- Prefer engineering reports over vague summaries.
- If status is uncertain, inspect the repo and report facts.
- Do not claim emulator verification unless it actually happened.
