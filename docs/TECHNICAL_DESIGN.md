# MARA — Technical Design

## Purpose

This document defines the initial technical direction for MARA.

It is intentionally conservative.

The goal is to establish a clean base for development without overengineering systems that may change once the game is playable.

The current priority is:

- build a stable first-person prototype
- create reusable core systems
- keep narrative logic separate from level-specific code
- make the project easy to extend with Codex
- avoid committing too early to complex architecture

---

# Engine

Engine:

Godot 4.x

Language:

GDScript

Renderer:

Forward+

Primary target:

Windows PC

---

# High-Level Architecture

MARA should be split into small reusable systems rather than one large game controller.

Initial major systems:

- PlayerController
- InteractionSystem
- NarrativeState
- DialogueSystem
- SaveManager
- SceneManager

Other systems such as:

- MARAController
- StoryEventSystem
- PassengerSystem
- DebugMenu

should be added only when the game actually needs them.

Avoid creating every planned system on day one.

---

# Global State

Only systems that genuinely need to exist across scenes should become Autoloads.

Likely candidates:

- NarrativeState
- SaveManager
- SceneManager

Do not automatically make every system global.

---

# Player

The player should use:

`CharacterBody3D`

Suggested hierarchy:

```text
Player
├── CollisionShape3D
├── Head
│   └── Camera3D
```

Later additions may include:

```text
InteractionRay
Flashlight
AudioListener
FootstepController
```

Initial player features:

- WASD movement
- mouse look
- gravity
- sprint
- crouch
- configurable mouse sensitivity

Movement should feel grounded and slightly heavy.

Avoid extremely fast FPS-style movement.

Suggested starting values:

```text
walk speed: 4.0 m/s
sprint speed: 6.0 m/s
crouch speed: 2.2 m/s
```

These values are not final and should be tuned by feel.

---

# Input

Input actions should be defined in `project.godot`.

Initial actions:

```text
move_forward
move_backward
move_left
move_right
sprint
crouch
interact
flashlight
pause
```

Do not hardcode raw keyboard keys inside gameplay scripts when an input action is appropriate.

---

# Interaction System

The player should use a reusable interaction system.

The player should not contain unique logic for every object.

A future interactable should expose a small public interface such as:

```gdscript
func interact(player):
    pass

func get_interaction_text() -> String:
    return "Interact"
```

Possible future interactables:

- doors
- terminals
- switches
- buttons
- logs
- inspectable objects
- maintenance controls

Interaction detection will likely use a raycast from the player's camera.

The exact implementation can be adjusted once the first prototype exists.

---

# Narrative State

MARA's story depends heavily on what the player has already discovered.

Narrative progress should not be stored entirely inside level scripts.

Create a central narrative state system when narrative work begins.

It should support simple named values such as:

```text
met_mara
restored_docking_power
learned_original_passenger_count
found_cryo_bodies
met_sarah_01
met_sarah_17
```

Initial API can be simple:

```gdscript
set_flag("met_mara", true)
has_flag("met_mara")
```

Later it should also support numeric or string values.

Example:

```text
sarah_instances_seen = 2
elias_instances_seen = 3
mara_state = "evasive"
```

Do not build a huge quest system unless the game proves it needs one.

---

# Dialogue

Main story dialogue should be authored.

Do not use an LLM to generate important dialogue at runtime.

Dialogue should eventually support:

- speaker
- text
- subtitles
- optional audio
- requirements
- state changes
- optional choices

Narrative data should preferably live outside scene scripts.

Possible locations:

```text
data/dialogue/
data/logs/
```

The exact data format can be decided later.

---

# Terminals

Terminals will be an important storytelling tool.

A reusable terminal system should eventually support:

- power state
- boot sequence
- text entries
- system logs
- passenger records
- MARA messages
- simple navigation

Later terminals may support:

- security feeds
- neural records
- system diagnostics
- consciousness instance lists

Do not build all terminal functionality during the first implementation.

Start simple.

---

# Doors

Doors should be reusable scenes.

Possible states:

```text
locked
unlocked
opening
open
closing
disabled
```

Doors should eventually be controllable by:

- player interaction
- story conditions
- power state
- MARA
- scripted events

Avoid writing unique door code inside every level.

---

# Scene Structure

Levels should be separate scenes where practical.

Initial planned areas may include:

```text
Docking Bay
Habitation
Cryogenic Sector
Engineering
Neural Research Wing
MARA Server Complex
Core
```

Do not build all of these immediately.

The first level should only be a small docking-area vertical slice.

---

# Save System

Save/load should be introduced after the first playable systems work.

Initial save data should eventually include:

- current scene
- player position
- narrative state
- current checkpoint
- basic settings if needed

A readable format such as JSON is acceptable early in development.

Do not serialize entire live scene trees.

---

# Audio

Audio is important to the game's atmosphere.

Use positional 3D audio where appropriate.

Important categories later:

- ventilation
- machinery
- electrical ambience
- metal stress
- footsteps
- terminals
- MARA voice
- passenger voices

Silence should be used deliberately.

Avoid constant music.

---

# UI

The UI should remain minimal.

Likely persistent or temporary UI elements:

- interaction prompt
- subtitles
- pause menu
- terminal interface

Avoid traditional game HUD elements unless needed.

---

# Debugging

Debug tools are encouraged early.

Useful future debug features:

- reload current scene
- teleport to area
- set narrative flag
- inspect narrative flags
- trigger dialogue
- unlock doors
- jump to checkpoint

Do not build a full debug menu before the first prototype unless needed.

---

# File Organization

Use the current project layout:

```text
assets/
data/
docs/
scenes/
scripts/
shaders/
```

Keep scene files under:

```text
scenes/characters/
scenes/levels/
scenes/props/
scenes/systems/
scenes/ui/
```

Keep scripts under:

```text
scripts/characters/
scripts/interactions/
scripts/systems/
scripts/ui/
```

Avoid putting large amounts of gameplay code directly in the project root.

---

# Coding Style

Use typed GDScript where it improves clarity.

Prefer:

- clear names
- small focused functions
- signals for decoupled communication
- reusable scenes
- simple systems

Avoid:

- giant manager classes
- unnecessary inheritance
- deeply nested dependencies
- hardcoded scene paths everywhere
- tightly coupling story logic to player movement code
- overengineering systems before they are needed

---

# Development Order

Initial development should happen in this order:

1. validate Godot project
2. create input map
3. build player controller
4. create simple test level
5. build interaction framework
6. create reusable door
7. create basic docking-bay graybox
8. create power interaction
9. create basic terminal system
10. add NarrativeState
11. add first MARA dialogue
12. connect the first vertical slice
13. add save/load
14. add debug tools
15. polish movement, lighting and audio

Do not start with:

- Elias
- Sarah duplication
- advanced MARA behavior
- large passenger systems
- full ship layout
- final choice systems

Those come later.

---

# First Vertical Slice

The first target should be a short playable sequence.

Flow:

1. Player arrives aboard ARK-7.
2. Player walks through an abandoned docking area.
3. Power is partially offline.
4. Player restores power.
5. A terminal activates.
6. MARA speaks for the first time.
7. MARA says:

   "12,184 passengers alive. Mission successful."

8. The player discovers a manifest showing that ARK-7 originally carried significantly fewer people.
9. A route deeper into the ship opens.
10. Vertical slice ends.

The goal is not to explain MARA yet.

The goal is to create curiosity and establish the tone.

---

# Codex Development Rules

Codex should always:

1. read `AGENTS.md`
2. read the relevant documentation
3. inspect the existing project before changing files
4. work on one bounded task
5. avoid implementing unrelated features
6. validate the project when possible
7. fix errors introduced by its own changes
8. report what changed

Codex should not commit or push unless explicitly instructed.

Preferred prompt style:

```text
Read AGENTS.md and relevant docs.

Implement only <feature>.

Inspect existing files before editing.

Do not implement unrelated systems.

Validate the project after implementation.

Fix errors introduced by this task.

Report:
- files changed
- behavior implemented
- validation performed
- remaining manual tests
```

---

# Current Technical Goal

The next development milestone is:

**first-person player controller + small movement test scene**

Nothing beyond that should be implemented yet.
