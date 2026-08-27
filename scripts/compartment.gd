extends Node

@onready var spawn_marker: Marker2D = $SpawnMarker
@onready var player = get_tree().get_first_node_in_group("player")
@onready var interactable: Interactable = %Interactable
@onready var sleeping_npc: Sprite2D = $SleepingNPC

func _ready() -> void:
	GameEvents.door_access_changed.connect(_on_door_access_changed)
	GameEvents.npc_invited.connect(_on_invite)

func move_player_to_spawn() -> void:
	player.global_position = spawn_marker.global_position

func peep_through_peephole() -> void:
	TransitionScene.transition_to("")

func _on_invite() -> void:
	sleeping_npc.visible = true

func _on_door_access_changed(is_acessible: bool) -> void:
	if is_acessible:
		interactable.monitoring = true
	else:
		interactable.monitoring = false
