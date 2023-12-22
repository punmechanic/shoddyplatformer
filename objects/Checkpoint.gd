class_name Checkpoint extends Node

signal passed

func spawn_player(player: Player):
	player.play_idle_animation()
	player.global_position = self.global_position

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		passed.emit()
