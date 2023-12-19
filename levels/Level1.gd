# TODO: Instead of having RespawnTimer be a child node and emitting a player_died, we should "lift"
# that logic so that the user provides a RespawnTimer or can decide whether or not to respawn the player
# by invoking a function.
#
# On the other hand, it would be really convenient to be able to instantiate levels without having
# to hook up the respawn logic. But, if we have RespawnTimer as a child of every level, then we have
# to configure the respawn timer. What we have now works so we'll keep it
extends Node2D

@export var player: CharacterBody2D

signal player_died;

func _ready():
	$SpawnPoint.spawn_player(player)

func _on_death_zone_body_entered(body: Node2D):
	if body is CharacterBody2D:
		$RespawnTimer.start()
		await $RespawnTimer.timeout
		$SpawnPoint.spawn_player(body)
		player_died.emit()
