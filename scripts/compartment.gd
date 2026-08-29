extends Node

@onready var spawn_marker: Marker2D = $SpawnMarker
@onready var bed_marker: Marker2D = $BedMarker
@onready var sleep_marker: Marker2D = $SleepMarker
@onready var player = get_tree().get_first_node_in_group("player")
@onready var stairs_interactable: Interactable = %StairsInteractable
@onready var bed_interactable: Interactable = %BedInteractable
@onready var sleeping_npc: Sprite2D = $SleepingNPC
@onready var killer: Node2D = $Killer

func _ready() -> void:
	GameEvents.door_access_changed.connect(_on_door_access_changed)
	GameEvents.day_phase_changed.connect(_on_day_phase_changed)
	GameEvents.day_count_changed.connect(_on_day_count_changed)
	GameEvents.npc_invited.connect(_on_invite)

func move_player_to_spawn() -> void:
	player.global_position = spawn_marker.global_position

func move_player_near_bed() -> void:
	player.global_position = bed_marker.global_position
	player.set_physics_process(true)
	player.wake_up()

func player_sleep() -> void:
	player.global_position = sleep_marker.global_position
	player.sleep()
	player.set_physics_process(false)

func _on_invite() -> void:
	sleeping_npc.visible = true
	sleeping_npc.process_mode = Node.PROCESS_MODE_INHERIT
	bed_interactable.monitoring = true
	GameEvents.has_sleeping_npc = true

func _on_day_phase_changed(phase: GameEvents.DayPhase) -> void:
	if phase == GameEvents.DayPhase.Bedtime:
		bed_interactable.monitoring = true
	else:
		bed_interactable.monitoring = false

func eliminate_the_player() -> void:
	killer.appear_and_kill()

func _on_day_count_changed() -> void:
	bed_interactable.monitoring = false
	sleeping_npc.visible = false
	sleeping_npc.process_mode = Node.PROCESS_MODE_DISABLED

func _on_door_access_changed(is_acessible: bool) -> void:
	if is_acessible:
		stairs_interactable.monitoring = true
	else:
		stairs_interactable.monitoring = false
