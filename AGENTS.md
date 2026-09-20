# MARA Development Instructions

MARA is a first-person psychological science-fiction horror game built in Godot 4 using GDScript.

The game takes place aboard ARK-7, an abandoned generation ship containing MARA, an advanced AI system capable of hosting digital human consciousnesses.

## Core development rules

- Use Godot 4.x.
- Use GDScript only unless explicitly instructed otherwise.
- Target Windows PC first.
- Use Forward+ rendering.
- Keep systems modular and reusable.
- Prefer composition over large inheritance trees.
- Do not put the entire game inside one script.
- Do not create massive manager classes unless necessary.
- Use typed GDScript where practical.
- Use signals to decouple systems where appropriate.
- Use reusable Godot scenes for interactable objects.
- Keep narrative content data-driven where practical.
- Do not add combat unless explicitly requested.
- Do not introduce monsters, ghosts, demons, zombies, or supernatural explanations.
- Psychological and existential horror should be prioritized over jump scares.
- Do not modify `docs/STORY.md` unless explicitly instructed.
- Do not significantly change existing architecture without explaining why.
- Preserve working systems when implementing new features.
- Fix errors introduced by a task before considering that task finished.

## Project structure

### `assets/`

Contains external game assets.

- `audio/` — ambience, dialogue, sound effects and music
- `materials/` — materials
- `models/` — imported 3D models
- `textures/` — textures

### `data/`

Contains narrative and game data.

- `dialogue/`
- `logs/`
- `passengers/`
- `story_events/`

Prefer Godot Resources or structured JSON for large narrative datasets.

### `docs/`

Project documentation.

- `STORY.md` — canonical story and lore
- `GAME_DESIGN.md` — gameplay design
- `ART_DIRECTION.md` — visual direction
- `TECHNICAL_DESIGN.md` — architecture and technical decisions

`STORY.md` is the canonical source for narrative information.

Do not rewrite established lore simply to make implementation easier.

### `scenes/`

Godot `.tscn` files.

- `characters/`
- `levels/`
- `props/`
- `systems/`
- `ui/`

### `scripts/`

GDScript source files.

- `characters/`
- `interactions/`
- `systems/`
- `ui/`

### `shaders/`

Godot shaders.

## Development philosophy

Build the game incrementally.

Do not attempt to generate the entire game in one pass.

Every development task should ideally follow:

1. Inspect the existing project.
2. Understand the relevant systems.
3. Implement one bounded feature.
4. Run appropriate validation.
5. Fix errors.
6. Report what changed.

Do not begin unrelated features after completing the requested task.

## First-person gameplay

The player will eventually support:

- WASD movement
- mouse look
- sprint
- crouch
- object interaction
- object inspection
- flashlight
- terminals
- doors
- environmental controls

The player should not have weapons during the initial development phases.

Movement should feel grounded rather than extremely fast or arcade-like.

## Interaction architecture

Interactions should eventually support reusable components for things such as:

- doors
- terminals
- buttons
- switches
- readable logs
- audio logs
- inspectable objects
- pickups
- story triggers
- maintenance controls

Avoid writing separate unrelated interaction logic for every prop.

## Narrative architecture

The story relies heavily on what the player has already discovered.

Narrative progression should therefore support state flags such as:

- visited locations
- discovered information
- conversations completed
- passenger instances encountered
- MARA behaviour state
- Elias encounters
- major revelations

Do not hardcode the entire game progression inside level scripts.

Prefer a dedicated game/narrative state system.

## MARA

MARA is not a conventional evil AI.

It follows its original purpose to preserve human consciousness, but its understanding of preservation becomes increasingly incompatible with human ideas of identity, death and individuality.

Avoid portraying MARA as randomly malicious.

MARA should generally be calm, precise and logical.

## Horror direction

Avoid relying on:

- constant jump scares
- gore
- random flickering
- loud noises with no narrative purpose
- visual glitches everywhere
- generic haunted-house tropes

Prefer:

- silence
- isolation
- conflicting information
- subtle environmental changes
- impossible questions about identity
- conversations with duplicated consciousnesses
- slow revelations
- environmental storytelling
- unsettling implications

## Code quality

- Prefer clear names over clever names.
- Keep functions focused.
- Avoid unnecessary global state.
- Document complicated systems.
- Remove dead code.
- Do not suppress errors to make the project appear functional.
- Avoid premature optimization.
- Avoid adding dependencies when Godot functionality is sufficient.

## Testing

When possible:

- run Godot validation/headless checks
- check scripts for parser errors
- verify referenced resources exist
- verify scene paths
- verify signals and node paths
- test the specific feature being implemented

Do not claim a feature works if it has not been tested when testing is available.

## Git

Do not commit unless explicitly asked.

Do not rewrite Git history.

Do not delete unrelated user changes.

## Current development stage

The project is currently in initial setup.

The first goal is a small vertical slice:

1. Player arrives aboard ARK-7.
2. Player explores the abandoned docking area.
3. Player restores power to a terminal.
4. MARA establishes contact.
5. MARA reports:

   "12,184 passengers alive. Mission successful."

6. The player discovers ARK-7 originally carried fewer passengers.
7. The route deeper into the ship opens.

The vertical slice should establish atmosphere and mystery before introducing the larger consciousness-copy storyline.
