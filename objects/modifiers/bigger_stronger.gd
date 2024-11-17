extends Node2D

func modify_player(player) -> void:
	player.damage_multiplier *= 1.6
	player.scale_multiplier += 0.3
