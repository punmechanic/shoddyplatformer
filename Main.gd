extends Node2D

@export var initial_level: Level;
@onready var level: Level = initial_level;

func _ready():
	level.spawn_player($Player)

func _on_player_died():
	$RespawnTimer.start()
	await $RespawnTimer.timeout
	level.spawn_player($Player)
