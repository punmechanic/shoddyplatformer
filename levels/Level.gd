class_name Level extends Node2D

@export var initial_spawn_point: Checkpoint
@onready var current_spawn_point: Checkpoint = initial_spawn_point
@export var tile_map: TileMap

var passed_checkpoints: Dictionary = {}

## Emitted when a checkpoint within the level is passed.
signal checkpoint_passed

func _on_passed_checkpoint(checkpoint: Checkpoint):
	# A checkpoint can only be passed once. After it's passed, we want to avoid a situation where
	# a player will spawn at a previous checkpoint if that player goes back to a previous area.
	if not checkpoint in passed_checkpoints:
		passed_checkpoints[checkpoint] = true
		current_spawn_point = checkpoint
		checkpoint_passed.emit(checkpoint)

func _ready():
	assert(tile_map != null, "Tile map is not set")
	assert(current_spawn_point != null, "This level has no initial checkpoint")	
	assert(self.list_checkpoints(), "This level has no checkpoints")
	for checkpoint in self.list_checkpoints():
		checkpoint.passed.connect(func(): _on_passed_checkpoint(checkpoint))

func spawn_player(player: Player) -> void:
	current_spawn_point.spawn_player(player)
	player.set_camera_extents_to_map(tile_map)

func list_checkpoints() -> Array[Checkpoint]:
	var points: Array[Checkpoint] = []
	for point in self.get_children():
		if point is Checkpoint:
			points.append(point)
	return points
