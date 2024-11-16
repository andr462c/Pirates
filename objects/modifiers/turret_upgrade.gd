extends Node2D

func modify_player(player: PlayerBoat) -> void:
	if player.get_node("Weapons").has_node("Turret"):
		var turret = player.get_node("Weapons").get_node("Turret")
		turret.shooting_timeout *= 0.9
		turret.number_of_bullets += 1
	else:
		var turret = preload("res://objects/weapons/Turret.tscn").instantiate()
		turret.number_of_bullets = 3
		player.get_node("Weapons").add_child(turret)
