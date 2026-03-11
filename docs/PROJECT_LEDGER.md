# Project Ledger

This file is the long-lived, append-only project record for this repository.

Rules for this file:
- Add new entries; do not rewrite or delete old entries.
- If a previous entry becomes outdated, add a newer entry that supersedes it.
- Record both shipped changes and active/incomplete work.
- Prefer concrete facts over summaries.

## Repo Purpose

This repository contains a small original NES homebrew action prototype built as a learning project.

Current locked architecture on `main`:
- pure 6502 assembly with `ca65` / `ld65`
- Mapper 0 / NROM-256
- iNES 1.0
- NTSC only
- fixed-screen rooms, no scrolling by design
- four-room prototype structure

## Repo Map

Top-level layout:
- `src/`
  - `core/`: reset, NMI, PPU, OAM, input, state dispatch
  - `game/`: player, collision, sword, enemies, combat, room loading, transitions, HUD, render
  - `data/`: palettes, text, rooms, metasprites
  - `screens/`: title, win, game-over
  - `audio/`: audio stub
- `assets/`
  - `maps/rooms.json`: room source data
  - `palettes/palettes.json`: palette source data
- `tools/`
  - `build_assets.py`: generates room/screen/CHR data
  - `validate_rom.py`: ROM/header validation
  - `smoke.py`: smoke helper
- `docs/`
  - `test-matrix.md`: very light manual test checklist

## Build And Validation

Known-good build commands on `main`:
- `make clean && make validate`
- `make smoke`

Current validation guarantees:
- assets generate
- ROM assembles and links
- header validation passes

Current validation does not guarantee:
- emulator-correct gameplay behavior
- completed audio integration
- completed art pipeline

## Current State Snapshot

State of `main` at the time this ledger was created:
- ROM builds successfully
- ROM boots in Mesen based on prior manual testing history
- title/gameplay/room loading/player/enemy/combat/end-state code all exist
- several earlier boot/render/room bugs were already fixed and merged
- room-transition behavior is still under active investigation
- audio remains stubbed
- source art pipeline is still generated/placeholder-driven rather than final PNG ingestion

## What Has Been Completed

Implemented in repo:
- linker/header/reset/NMI boot path
- controller input path
- player movement and facing
- collision system
- fixed-room loader
- sword state and hit logic
- enemy spawn/update/combat path
- HUD hearts
- title screen
- win/game-over screens
- ROM build and header validation

Merged fixes already on `main`:
- fixed reset stack corruption during RAM clear
- fixed `Up` movement direction selection
- made playfield origin explicit in collision code
- fixed player render tile-pair indexing
- fixed room transition spawn inversion
- aligned room doorway layout data
- restored PPU scroll latch after queued writes
- fixed enemy spawn record stride

## Known Intentional Gaps

Still incomplete by design or not yet implemented:
- final PNG-based asset pipeline
- FamiStudio integration
- robust automated emulator test coverage
- full project documentation beyond this ledger and the minimal test matrix
- final cleanup of room-transition edge cases

## Open Work Queue

Current known or likely next tasks:
- finish debugging room-transition behavior end-to-end
- verify north/south doorway behavior against actual room data and intended exits
- verify post-transition player control restoration in live emulator runs
- decide whether to keep or remove temporary debug instrumentation work before merging anything related to it
- expand docs with emulator workflow and debugging notes
- replace placeholder/generated art flow with source PNG ingestion when gameplay stabilizes
- add music/SFX integration only after gameplay is stable
- turn the test matrix into a more concrete phase/status checklist

## Historical Record

### Entry 2026-03-10 - Initial ledger created

Reason:
- The repo needed a durable documentation file that can track both completed work and remaining work without losing history.

Observed repo status at entry time:
- `README` is minimal and does not document architecture or progress.
- `docs/test-matrix.md` exists but is only a short checklist.
- Recent merged work on `main` includes doorway layout, scroll latch restoration, and enemy spawn stride fixes.
- Additional room-transition debugging work exists outside `main` and is not yet treated as shipped.

Known recent merged commits visible in history:
- `407e8dc` `align room doorway layout`
- `5180e95` `restore scroll latch after ppu queue flush`
- `c7b12ff` `fix enemy spawn record stride`
- earlier merged fixes also include room-transition spawn correction, player render tile-pair correction, and reset-path repair

Decision:
- Use this ledger as the canonical append-only status file for the repository.
- Future progress updates should be added as new dated entries below this one.

### Entry 2026-03-10 - Documentation and active-debug status update

Reason:
- The repo needed better discoverability and a clearer handoff path for future sessions.
- We also needed to capture the current state of active debugging work without rewriting earlier entries.

Documentation changes made:
- Added a real repository `README`
- Added a rehydration/bootstrap prompt document for future sessions
- Kept this ledger as the append-only source for project history and status

State of `main` at this point:
- `main` includes the merged fixes for doorway layout, scroll latch restoration, and enemy spawn stride
- `main` builds cleanly with `make clean && make validate`
- Room-transition behavior is still not considered fully resolved

Known active debugging context at this point:
- There is a local branch named `codex/transition-debug-and-postload`
- That branch contains temporary transition instrumentation and post-load state clearing work
- It has not been merged because it is still investigative rather than clearly fix-complete

Working agreement captured at this point:
- `main` should stay buildable and reflect merged fixes
- debug/instrumentation work should remain isolated on non-main branches until proven
- future sessions should read the README, this ledger, and the rehydration prompt before making assumptions
