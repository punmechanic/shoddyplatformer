extends Node2D

func _ready():
	$SpawnPoint.spawn_player($Player)

func _on_death_zone_body_entered(body: Node2D):
	if body is CharacterBody2D:
		$SpawnPoint.spawn_player(body)

