extends Node2D

func _ready():
	$Level1.spawn_player($Player)

func _on_level_1_player_died():
	$RespawnTimer.start()
	await $RespawnTimer.timeout
	$Level1.spawn_player($Player)
