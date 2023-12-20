class_name Player extends CharacterBody2D

@export var speed = 300.0
@export var jump_velocity = -400.0

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

	move_and_slide()

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
