extends Node

## Central, lightweight state store for discoveries and narrative progression.
## Systems can react to changes through signals without placing story state in levels.

signal value_changed(key: StringName, previous_value: Variant, current_value: Variant)
signal flag_changed(flag: StringName, enabled: bool)

var values: Dictionary = {}


func set_flag(flag: StringName, enabled: bool = true) -> void:
	set_value(flag, enabled)


func has_flag(flag: StringName) -> bool:
	return get_value(flag, false) == true


func set_value(key: StringName, value: Variant) -> void:
	if key.is_empty():
		push_error("NarrativeState requires a non-empty key.")
		return

	var had_previous_value := values.has(key)
	var previous_value: Variant = values.get(key)
	if had_previous_value and previous_value == value:
		return

	values[key] = value
	value_changed.emit(key, previous_value, value)
	if value is bool:
		flag_changed.emit(key, value)


func get_value(key: StringName, default_value: Variant = null) -> Variant:
	return values.get(key, default_value)


func clear_value(key: StringName) -> void:
	if not values.has(key):
		return

	var previous_value: Variant = values[key]
	values.erase(key)
	value_changed.emit(key, previous_value, null)
	if previous_value is bool:
		flag_changed.emit(key, false)


func reset() -> void:
	var existing_keys: Array = values.keys()
	for key in existing_keys:
		clear_value(StringName(key))
