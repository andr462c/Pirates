extends Node2D

func modify_player(player) -> void:
	player.max_health = 20
	var hp_bar = get_node("/root/Main/Healthbars/P%dHealth" % player.id)
	hp_bar.max_value = player.max_health
