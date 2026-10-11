# MARA Development Log

This is an append-only record of significant implementation and documentation work.
It provides practical project context between development sessions. Each entry should
record the date, scope, files or systems affected, validation, commit reference when
applicable, and any remaining manual test or follow-up work.

## Current Snapshot

- Engine: Godot 4.7, Forward+ renderer, Windows-first target.
- Current remote default branch: `main`.
- Current playable scene: `res://scenes/levels/movement_test.tscn`.
- Current milestone: first-person controller and interaction prototype; the docking-bay
  vertical slice has not yet been built.
- Narrative direction: ARK-7's crew and passengers are represented by MARA as digital
  consciousnesses; the opening mystery is the discrepancy between the original manifest
  and MARA's reported passenger count.

## 2026-09-20 — Project Foundation

### Completed

- Created the Godot project and its initial directory structure.
- Added the technical design, game design, art direction, and initial story documents.

### References

- `27dd634` — `chore: initialize MARA project and story`
- `3791091` — `docs: add initial technical design`
- `58b88d4` — `docs: add initial game design`
- `bb415fa` — `docs: add initial art direction`

## 2026-09-20 — First-Person Player Controller

### Completed

- Added a reusable `CharacterBody3D` player scene and typed controller.
- Implemented WASD movement, gravity, mouse look, sprint, crouch, and head bob.
- Created a primitive movement test scene with collision, walls, crates, and basic
  lighting.
- Added input actions for movement, sprint, crouch, interaction, flashlight, and pause.

### References

- `daa1ff6` — `feat: add first person player controller`
- `67ac5f5` — merged the player-controller branch into `main`.

### Notes

- The remote `feature/player-controller` branch was deleted after its merge.
- Flashlight input and a light node exist, but switching behavior is not implemented.

## 2026-10-11 — Narrative Foundation Expansion

### Completed

- Expanded the canonical story document with the Continuity Crisis, MARA's origin,
  Continuity Images, the ARK-7 systems failure, Elias Venn's decision, branching
  consciousnesses, and the colony investigation framing.
- Clarified the core ethical question: how to value multiple conscious versions of one
  person when physical embodiment is limited.

### Reference

- `b4d72dd` — `docs: expand ARK-7 narrative foundation` (pushed to `main`).

## 2026-10-11 — Reusable Interaction Prototype

### Completed

- Added an `Interactable` component that exposes interaction text and emits an
  interaction signal.
- Added a camera-raycast `InteractionSystem` that finds interactable components and
  routes the `interact` input action.
- Added a minimal in-world interaction prompt.
- Added a reusable test button that changes material and indicator-light state when
  interacted with.
- Integrated the test button into the movement scene.

### Reference

- `f192c0e` — `feat: add reusable first-person interaction prototype`.

### Status

- This commit is currently on the local `feature/interaction-system` branch only; it
  has not been merged or pushed to `main`.
- Godot was not available on PATH during verification, so a headless project check was
  not run. The feature still needs an in-editor movement and interaction test.

## Next Recommended Task

Create a reusable door scene that composes with the interaction system and supports
locked/unlocked and open/closed states. Test it in `movement_test.tscn` before using it
in the docking-bay graybox.

## Entry Template

```md
## YYYY-MM-DD — Short Task Name

### Completed

- What changed and why.

### Validation

- Commands, checks, and manual tests performed.

### References

- `commit-sha` — commit message, if committed.

### Follow-Up

- Explicit remaining work or manual verification.
```
