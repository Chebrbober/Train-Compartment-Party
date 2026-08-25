extends Node2D

@onready var compartment = $Compartment
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
@onready var peephole_camera: Camera2D = %PeepholeCamera
@onready var train_group: CanvasGroup = $TrainGroup
@onready var inside: Node2D = %Inside
@onready var fish_eye: CanvasLayer = %FishEye
enum TrainState {
	Corridor,
	Compartment,
	Peeping
}

var current_train_state: TrainState = TrainState.Corridor:
	set(v):
		if v == TrainState.Compartment:
			fish_eye.visible = false
			peephole_camera.enabled = false
			player.camera.enabled = true
			compartment.visible = true
			train_group.visible = false
			fish_eye.visible = false
			train_group.process_mode = Node.PROCESS_MODE_DISABLED

		elif v == TrainState.Peeping:
			train_group.process_mode = Node.PROCESS_MODE_INHERIT
			player.camera.enabled = false
			peephole_camera.enabled = true
			compartment.visible = false
			train_group.visible = true
			inside.visible = false
			fish_eye.visible = true

		current_train_state = v
var is_transitioning: bool = false

func _ready() -> void:
	InteractManager.pressed.connect(_on_interact_pressed)
	fish_eye.visible = false

func _on_interact_pressed(interactable: Interactable) -> void:
	if not interactable or is_transitioning:
		return

	match interactable.interact_type:
		Interactable.Type.DOOR:
			if current_train_state == TrainState.Corridor:
				is_transitioning = true
				enter_compartment()
			elif current_train_state == TrainState.Compartment:
				is_transitioning = true
				start_peeping()

func enter_compartment() -> void:
	TransitionScene.transition_to("",
		func() -> void:
			current_train_state = TrainState.Compartment
			player.move_on_y_axis = true
			compartment.move_player_to_spawn()
			is_transitioning = false
			)

func start_peeping() -> void:
	print("The player is looking in the peephole")
	TransitionScene.transition_to("",
		func() -> void:
			current_train_state = TrainState.Peeping
			is_transitioning = false
			peephole_camera.enabled = true
			player.camera.enabled = false
			fish_eye.visible = true
			print("changed the camera")
			)
	player.set_physics_process(false)

func stop_peeping() -> void:
	print("The player closed the peephole")
	enter_compartment()
	player.set_physics_process(true)
