extends Level

func _on_death_zone_body_entered(body: Node2D):
	# TODO: This probably shouldn't be handled in each level, but handling it in the player script is clumsy,
	# because at present the player script doesn't provide a way of listening to any collision on a particular layer or mask,
	# since it's a CharacterBody2D.
	if body is Player:
		body.kill()

func spawn_player(player: Player) -> void:
	$SpawnPoint.spawn_player(player)
