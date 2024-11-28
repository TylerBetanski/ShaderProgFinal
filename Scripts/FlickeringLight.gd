class_name FlickeringLight extends Node

@export var light : Light3D
@export_range(0, 1) var flicker_intensity : float = 0.2

var initial_light_intensity : float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initial_light_intensity = light.light_energy


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	light.light_energy = randf_range(flicker_intensity, 1)
