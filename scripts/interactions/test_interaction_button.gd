extends StaticBody3D

## Movement-test-only consumer of Interactable. Future props can replace this
## script while retaining the same Interactable child component.

@export var inactive_color := Color(0.18, 0.22, 0.25, 1.0)
@export var active_color := Color(0.22, 0.8, 0.62, 1.0)

@onready var interactable: Interactable = $Interactable
@onready var button_mesh: MeshInstance3D = $ButtonMesh
@onready var indicator_light: OmniLight3D = $IndicatorLight

var is_active := false


func _ready() -> void:
	interactable.interacted.connect(_on_interacted)
	_update_visual_state()


func _on_interacted(_player: Node) -> void:
	is_active = not is_active
	_update_visual_state()


func _update_visual_state() -> void:
	var material := StandardMaterial3D.new()
	var color := active_color if is_active else inactive_color
	material.albedo_color = color
	material.metallic = 0.5
	material.roughness = 0.45
	material.emission_enabled = is_active
	material.emission = color
	button_mesh.material_override = material
	indicator_light.light_color = color
	indicator_light.light_energy = 2.0 if is_active else 0.25
