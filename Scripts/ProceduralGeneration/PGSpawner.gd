class_name PGSpawner extends Node3D

@export var bounds : AABB = AABB(Vector3.ZERO, Vector3.ONE)
@export var floor_offset : float = 0.
@export var min_spawns : float = 0.0
@export var max_spawns : float = 1.0
@export var objects : Array[PGSpawn]
@export var allow_self_intersection : bool = true
@export_flags_3d_physics var exclusion_mask : int

var _spawned_objects : Array[Node3D]
var _total_weight : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var i := 0
	while i < objects.size():
		if objects[i] != null and objects[i].object != null:
			_total_weight += objects[i].weight
		else:
			objects.remove_at(i)
			i = i - 1
		
		i = i + 1
	_spawn()

func _spawn() -> void:
	for i in range(0, randi_range(min_spawns, max_spawns)):
		_spawn_object(_get_random_object(), _get_random_position_in_bounds())

func _get_random_position_in_bounds() -> Vector3:
	return (global_position + bounds.position + 
			Vector3(randf_range(-0.5, 0.5) * bounds.size.x,
			0,
			randf_range(-0.5, 0.5) * bounds.size.z))

func _get_random_object() -> PackedScene:
	var selected_weight := randi_range(0, _total_weight)
	var current_weight := 0
	for pg_spawn in objects:
		if selected_weight >= current_weight && selected_weight <= current_weight + pg_spawn.weight:
			return pg_spawn.object
		current_weight = current_weight + pg_spawn.weight
	return null

func _spawn_object(object : PackedScene, pos : Vector3) -> void:
	var spawned = object.instantiate() as MeshInstance3D
	add_child(spawned)
	_spawned_objects.append(spawned)
	spawned.global_position = pos
	spawned.global_position += Vector3.UP * (floor_offset + spawned.get_aabb().size.y/2.0)
