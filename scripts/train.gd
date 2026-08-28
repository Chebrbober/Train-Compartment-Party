extends Node2D

@export var shader_resource: ShaderMaterial
@onready var compartment = $Compartment
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
@onready var peephole_camera: Camera2D = %PeepholeCamera
@onready var train_group: CanvasGroup = $TrainGroup
@onready var inside: Node2D = %Inside
@onready var peephole_hud: CanvasLayer = %PeepholeHUD
@onready var guest_manager: Node = $GuestManager
var is_transitioning: bool = false


func _ready() -> void:
	InteractManager.pressed.connect(_on_interact_pressed)
	peephole_hud.lock_pressed.connect(guest_manager.anger)
	peephole_hud.open_pressed.connect(guest_manager.invite)
	GameEvents.train_state_changed.connect(update_visibility)
	GameEvents.npc_raged.connect(stop_peeping)
	GameEvents.npc_invited.connect(stop_peeping)

func update_visibility(state) -> void:
	if state == GameEvents.TrainState.Compartment:
		peephole_camera.enabled = false
		player.camera.enabled = true
		compartment.visible = true
		train_group.visible = false
		train_group.material = null
		peephole_hud.visible = false

	elif state == GameEvents.TrainState.Peeping:
		player.camera.enabled = false
		peephole_camera.enabled = true
		compartment.visible = false
		train_group.visible = true
		inside.visible = false
		train_group.material = shader_resource
		peephole_hud.visible = true

func _on_interact_pressed(interactable: Interactable) -> void:
	if not interactable or is_transitioning:
		return

	match interactable.interact_type:
		Interactable.Type.DOOR:
			if GameEvents.current_train_state == GameEvents.TrainState.Corridor:
				is_transitioning = true
				enter_compartment()
			elif GameEvents.current_train_state == GameEvents.TrainState.Compartment:
				is_transitioning = true
				start_peeping()

func enter_compartment() -> void:
	TransitionScene.transition_to("",
		func() -> void:
			GameEvents.current_train_state = GameEvents.TrainState.Compartment
			player.move_on_y_axis = true
			compartment.move_player_to_spawn()
			guest_manager.reset_timer()
			is_transitioning = false
			)

func start_peeping() -> void:
	print("The player is looking in the peephole")
	TransitionScene.transition_to("",
		func() -> void:
			GameEvents.current_train_state = GameEvents.TrainState.Peeping
			is_transitioning = false
			peephole_camera.enabled = true
			player.camera.enabled = false
			print("changed the camera")
			)
	player.set_physics_process(false)

func stop_peeping() -> void:
	print("The player closed the peephole")
	enter_compartment()
	player.set_physics_process(true)
