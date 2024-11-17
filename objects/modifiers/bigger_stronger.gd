extends Node2D

func modify_player(player) -> void:
	player.damage_multiplier *= 1.3
	player.scale_multiplier *= 1.2
