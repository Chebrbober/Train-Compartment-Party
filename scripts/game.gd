extends Node2D

@onready var parallax_bg: Node2D = $ParallaxBackground

func _ready() -> void:
	GameEvents.train_state_changed.connect(update_visibility)

func update_visibility(state: GameEvents.TrainState) -> void:
	if state == GameEvents.TrainState.Compartment:
		parallax_bg.visible = false
	elif state == GameEvents.TrainState.Corridor:
		parallax_bg.visible = true
