extends Node2D

@onready var compartment = $Compartment
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
@onready var train_group: CanvasGroup = $TrainGroup
enum TrainState {
	Corridor,
	Compartment
}
var current_train_state: TrainState = TrainState.Corridor:
	set(v):
		if v == TrainState.Compartment:
			compartment.visible = true
			train_group.process_mode = Node.PROCESS_MODE_DISABLED
		else:
			compartment.visible = false
			train_group.process_mode = Node.PROCESS_MODE_INHERIT
		current_train_state = v
var is_transitioning: bool = false

func _ready() -> void:
	InteractManager.pressed.connect(_on_interact_pressed)

func _on_interact_pressed(interactable: Interactable) -> void:
	if not interactable or is_transitioning:
		return

	match interactable.interact_type:
		Interactable.Type.DOOR:
			if current_train_state == TrainState.Corridor:
				is_transitioning = true
				enter_compartment()
			else:
				compartment.peep_through_peephole()

func enter_compartment() -> void:
	TransitionScene.transition_to("",
		func() -> void:
			current_train_state = TrainState.Compartment
			player.move_on_y_axis = true
			compartment.move_player_to_spawn()
			is_transitioning = false
			)
