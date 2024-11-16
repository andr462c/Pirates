extends Node2D

func modify_player(player: PlayerBoat) -> void:
	if player.get_node("Weapons").has_node("Rpg"):
		var turret = player.get_node("Weapons").get_node("Rpg")
		turret.shooting_timeout *= 0.8
		turret.kill_time += 2
		turret.speed += 500
	else:
		var turret = preload("res://objects/weapons/rpg.tscn").instantiate()
		player.get_node("Weapons").add_child(turret)
