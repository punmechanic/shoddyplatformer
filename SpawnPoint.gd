extends RayCast2D

func _ready():
	print(is_colliding());

func spawn_player(player: CharacterBody2D):
	force_raycast_update();
	print(is_colliding());
	print("spawn player")
	pass
