extends CharacterBody2D


@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta: float):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	var is_jumping: bool = false
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		$Sprite.play("jump")
		velocity.y = JUMP_VELOCITY
		is_jumping = true

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		# Only change the facing direction if the player actually changed how they are facing.
		# This prevents the sprite "snapping" back to facing left after the player stops pressing the right direction.
		$Sprite.flip_h = direction > 0
		# TODO: Don't play the walking animation when the player is jumping./
		$Sprite.play("walk")
	else:
		# Player is stood still.
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	# If the player is not jumping AND the player has no direction, the player is stood still and should idle.
	# We still want the walking animation to play if the player has a direction even if the player can't move.
	#
	# This is done after move_and_slide() because move_and_slide() will change the state of is_on_floor() to reflect
	# any jumps that occurred during this frame.
	if is_on_floor() and direction == 0:
		$Sprite.play("idle")
