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

Add the original passenger manifest as the contradictory evidence after MARA's first
terminal message is validated.

## 2026-10-11 — MARA First Contact

### Completed

- Added the first MARA terminal message to the powered docking terminal: “12,184
  passengers alive. Mission successful.”
- Added a reusable terminal narrative trigger that records discoveries through
  `NarrativeState` when a terminal is first opened.
- Set the `met_mara` flag on the first terminal access.

### Follow-Up

- Manually verified in Godot: the message appears after local power is restored and
  `NarrativeState` records `met_mara` on terminal access.
- Next, add the original passenger manifest as contradictory evidence.

## 2026-10-11 — Narrative State Foundation

### Completed

- Added `NarrativeState` as an autoloaded state store for flags and generic values.
- Added named flag/value accessors and change signals for decoupled narrative systems.
- Kept narrative behavior out of scenes and reusable prop scripts.

### Follow-Up

- Manually verified in Godot: the project starts without errors and `NarrativeState`
  appears under `/root` in the Remote scene tree.
- Next, add MARA's first docking-bay terminal message.

## 2026-10-11 — Docking Terminal

### Completed

- Added a reusable, power-gated terminal scene using the shared interaction component.
- Added a minimal terminal overlay with a boot/status message and a 3D screen state.
- Connected the docking power console to activate the terminal once local power returns.

### Follow-Up

- Manually verified in Godot: the terminal remains offline before power restoration,
  becomes ready afterward, and opens/closes its display through interaction.
- Next, add a lightweight narrative-state system.

## 2026-10-11 — Docking Power Interaction

### Completed

- Added a reusable power-console scene driven by the shared interaction component.
- Added a `power_restored` signal so levels can connect power activation to other
  systems without level-specific interaction code.
- Added the console to the docking-bay maintenance area and connected it directly to
  unlock the inner pressure door.
- Added a short, enclosed staging corridor beyond the door so the player remains within
  the level after opening it.

### Follow-Up

- Manually verified in Godot: restoring power updates the console state, unlocks the
  inner door, and allows the player to safely enter the staging corridor.
- Next, create a basic docking-bay terminal system.

## 2026-10-11 — Docking-Bay Graybox

### Completed

- Added a playable docking-arrival scene as the project startup scene.
- Built a compact graybox with an arrival platform, outer docking wall, maintenance
  alcove, emergency lighting, clutter, and a sealed inner pressure door.
- Kept the inner door locked to establish the later power-restoration objective without
  implementing its logic ahead of schedule.

### Follow-Up

- Manually verified in Godot: player scale and navigation are readable, the maintenance
  area is accessible, the scene boundaries hold, and the inner door correctly remains
  locked.
- Next, implement the local-power interaction that unlocks the inner pressure door.

## 2026-10-11 — Reusable Sliding Door

### Completed

- Added a reusable sliding door scene with a moving physical panel and interaction
  component.
- Added open, close, lock, unlock, and disable public controls for later narrative,
  power, MARA, and scripted-event integrations.
- Added explicit states for disabled, locked, closed, opening, open, and closing.
- Added a test door to the movement test scene.

### Validation

- Confirmed scene resource paths and script references structurally.
- Ran a whitespace check with no reported diff errors.
- Manually tested in Godot: interaction prompts update correctly; the door opens and
  closes; the opening becomes traversable; and the closed panel blocks player movement.
- Godot was unavailable on the Windows PATH and WSL execution was denied, so a headless
  runtime check was not available.

### Follow-Up

- Run a Godot editor/headless validation and manually verify the door opens and closes
  without obstructing the player before building the docking-bay graybox.

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
