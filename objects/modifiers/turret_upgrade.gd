extends Node2D

func modify_player(player: PlayerBoat) -> void:
	if player.get_node("Weapons").has_node("Turret"):
		var turret = player.get_node("Weapons").get_node("Turret")
		turret.shooting_timeout *= 0.1
	else:
		player.get_node("Weapons").add_child(preload("res://objects/weapons/Turret.tscn").instantiate())
