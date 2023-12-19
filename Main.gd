extends Node2D

func _ready():
	$SpawnPoint.spawn_player($Player)

func _on_death_zone_body_entered(body: Node2D):
	if body is CharacterBody2D:
		$RespawnTimer.start()
		await $RespawnTimer.timeout
		$SpawnPoint.spawn_player(body)
