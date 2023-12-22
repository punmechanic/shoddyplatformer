class_name Player extends CharacterBody2D

@export var speed = 300.0
@export var jump_velocity = -400.0
## The name of the deep water data layer in a tile map. Touching deep water instantly kills the player.
## This hack is done because CharacterBody2D doesn't provide a convenient way for identifying a collision with any particular tile, instead we have to iterate through each tile of a tilemap whenever a collision is made.
@export var deep_water_layer_name = "deep_water"

signal died

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

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
				self.kill()
	
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

### Kills the player, playing the death animation and emitting a death event.
func kill():
	died.emit()

func play_idle_animation():
	$Sprite.play("idle")
