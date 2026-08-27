extends Node2D

@export var shader_resource: ShaderMaterial
@onready var compartment = $Compartment
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
@onready var peephole_camera: Camera2D = %PeepholeCamera
@onready var train_group: CanvasGroup = $TrainGroup
@onready var inside: Node2D = %Inside
@onready var body: Sprite2D = %Body
@onready var peephole_hud: CanvasLayer = %PeepholeHUD

var current_train_state: GameEvents.TrainState = GameEvents.TrainState.Corridor:
	set(v):
		if v == GameEvents.TrainState.Compartment:
			peephole_camera.enabled = false
			player.camera.enabled = true
			compartment.visible = true
			train_group.visible = false
			train_group.process_mode = Node.PROCESS_MODE_DISABLED
			body.material = null
			peephole_hud.visible = false

		elif v == GameEvents.TrainState.Peeping:
			train_group.process_mode = Node.PROCESS_MODE_INHERIT
			player.camera.enabled = false
			peephole_camera.enabled = true
			compartment.visible = false
			train_group.visible = true
			inside.visible = false
			body.material = shader_resource
			peephole_hud.visible = true

		current_train_state = v
		GameEvents.train_state_changed.emit(v)
var is_transitioning: bool = false

func _ready() -> void:
	InteractManager.pressed.connect(_on_interact_pressed)
	peephole_hud.lock_pressed.connect(stop_peeping)

func _on_interact_pressed(interactable: Interactable) -> void:
	if not interactable or is_transitioning:
		return

	match interactable.interact_type:
		Interactable.Type.DOOR:
			if current_train_state == GameEvents.TrainState.Corridor:
				is_transitioning = true
				enter_compartment()
			elif current_train_state == GameEvents.TrainState.Compartment:
				is_transitioning = true
				start_peeping()

func enter_compartment() -> void:
	TransitionScene.transition_to("",
		func() -> void:
			current_train_state = GameEvents.TrainState.Compartment
			player.move_on_y_axis = true
			compartment.move_player_to_spawn()
			is_transitioning = false
			)

func start_peeping() -> void:
	print("The player is looking in the peephole")
	TransitionScene.transition_to("",
		func() -> void:
			current_train_state = GameEvents.TrainState.Peeping
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
