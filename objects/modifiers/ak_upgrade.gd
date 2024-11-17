extends Node2D

func modify_player(player: PlayerBoat) -> void:
	if player.get_node("Weapons").has_node("Ak47"):
		var turret = player.get_node("Weapons").get_node("Ak47")
		turret.shooting_timeout *= 0.6
		turret.kill_time += 1
		turret.speed += 500
		turret.pattern = preload("res://objects/bullets/bullet_patterns/bullet_pattern3_Sine.tscn")
	else:
		var turret = preload("res://objects/weapons/ak47.tscn").instantiate()
		player.get_node("Weapons").add_child(turret)
