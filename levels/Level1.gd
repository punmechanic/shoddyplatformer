extends Node2D

signal player_died;

func _on_death_zone_body_entered(body: Node2D):
	if body is CharacterBody2D:
		player_died.emit()

func spawn_player(player: CharacterBody2D):
	$SpawnPoint.spawn_player(player)
