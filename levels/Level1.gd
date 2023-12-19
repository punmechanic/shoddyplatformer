extends Level

func _on_death_zone_body_entered(body: Node2D):
	# TODO: It would be better to have this collision handled within the player, by creating a collision
	# shape around the player that specifically only listens to insta-death events on the dead zone collision layer.
	if body is Player:
		body.kill()

func spawn_player(player: Player) -> void:
	$SpawnPoint.spawn_player(player)
