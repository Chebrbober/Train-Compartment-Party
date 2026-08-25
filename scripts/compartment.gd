extends Node

@onready var spawn_marker: Marker2D = $SpawnMarker
@onready var player = get_tree().get_first_node_in_group("player")

func move_player_to_spawn() -> void:
	player.global_position = spawn_marker.global_position

func peep_through_peephole() -> void:
	pass
