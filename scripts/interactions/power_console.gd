class_name PowerConsole
extends StaticBody3D

## Reusable local power control. Levels decide what restored power enables by
## connecting power_restored to doors, terminals, lights, or other systems.

signal power_restored

@export var starts_powered: bool = false
@export var inactive_color := Color(0.78, 0.38, 0.2, 1.0)
@export var active_color := Color(0.24, 0.78, 0.62, 1.0)

@onready var interactable: Interactable = $Interactable
@onready var status_light: OmniLight3D = $StatusLight
@onready var status_mesh: MeshInstance3D = $StatusMesh

var is_powered := false


func _ready() -> void:
	interactable.interacted.connect(_on_interacted)
	set_powered(starts_powered)


func set_powered(value: bool) -> void:
	var was_powered := is_powered
	is_powered = value
	_update_visual_state()
	if is_powered and not was_powered:
		power_restored.emit()


func _on_interacted(_player: Node) -> void:
	if is_powered:
		return

	set_powered(true)


func _update_visual_state() -> void:
	var color := active_color if is_powered else inactive_color
	interactable.interaction_text = "Power Restored" if is_powered else "Restore Docking Power"

	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.emission_enabled = true
	material.emission = color
	material.emission_energy_multiplier = 1.2
	status_mesh.material_override = material
	status_light.light_color = color
	status_light.light_energy = 1.4 if is_powered else 0.35
