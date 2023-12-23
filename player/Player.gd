class_name Player extends CharacterBody2D

@export var speed = 300.0
@export var jump_velocity = -400.0
## The name of the deep water data layer in a tile map. Touching deep water instantly kills the player.
## This hack is done because CharacterBody2D doesn't provide a convenient way for identifying a collision with any particular tile, instead we have to iterate through each tile of a tilemap whenever a collision is made.
@export var deep_water_layer_name = "deep_water"

signal died

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

## Alters the player camera to match the extents of the TileMap.
##
## This prevents the player from seeing any further west or east than the furthest tile in that cardinal direction.
func set_camera_extents_to_map(map: TileMap) -> void:
	var extents = map.get_used_rect()
	var west = map.map_to_local(extents.position)
	var east = map.map_to_local(extents.end)
	$Camera2D.limit_left = west.x
	# I don't currently know why but it appears that Godot "rounds up" the end extent to that of the next tile increment. That is, the end appears to be TILE_SIZE more east than it should be.
	# This is a hack fix but it would be good to know why it does this.
	$Camera2D.limit_right = east.x - map.tile_set.tile_size.x
	# We don't currently set a limit_up because this would require us to define a ceiling in our tile map, which would make parallax backgrounds difficult.
	# There's probably a way to do this but I don't care.

	# 'east' is the bottom right corner of the map. Therefore, it's y value will work.
	# This has the same bug as limit_right, where we need to subtract one tile.
	$Camera2D.limit_bottom = east.y - map.tile_set.tile_size.y

func _physics_process(delta: float):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * speed
	else:
		# Player is stood still.
		velocity.x = move_toward(velocity.x, 0, speed)

	# TODO: This is currently bugged and will only trigger if a player collides with a wall,
	# instead of if a player moves on the water.
	if move_and_slide():
		var collision = get_last_slide_collision()
		var collider = collision.get_collider()
		if collider is TileMap:
			var layer_id = collider.get_layer_for_body_rid(collision.get_collider_rid())
			var coords = collider.local_to_map(collision.get_position())
			var tile: TileData = collider.get_cell_tile_data(layer_id, coords)
			if tile != null && tile.get_custom_data(deep_water_layer_name):
				# This triggers MANY times and only takes affect once the player leaves the dead zone.
				# My guess is that multiple invocations continually reset the timer.
				# We can solve this by having a dead state, and transitioning the player to that state, and only emitting state change notifications if appropriate.
				kill()
	
	# If the player is not jumping AND the player has no direction, the player is stood still and should idle.
	# We still want the walking animation to play if the player has a direction even if the player can't move.
	#
	# This is done after move_and_slide() because move_and_slide() will change the state of is_on_floor() to reflect
	# any jumps that occurred during this frame.
	if is_on_floor():
		if direction != 0:
			$Sprite.play("walk")
		else:
			$Sprite.play("idle")
	else:
		$Sprite.play("jump")
	# Change facing direction if the axis indicates that we should (ie its over or under 0).
	if direction != 0:
		$Sprite.flip_h = direction > 0

# TODO: Refactor this into a state machine for all possible player states.
var is_dead: bool = false

### Kills the player, playing the death animation and emitting a death event.
func kill():
	if is_dead:
		return
	is_dead = true
	died.emit()

func play_idle_animation():
	$Sprite.play("idle")
