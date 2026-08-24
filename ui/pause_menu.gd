extends CanvasLayer

@export_file("*.tscn") var main_menu_scene: String

func _ready() -> void:
	visible = false
	get_tree().paused = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if get_tree().paused:
			visible = false
			get_tree().paused = false
		else:
			visible = true
			get_tree().paused = true

func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	TransitionScene.transition_to(main_menu_scene)

func _on_resume_pressed() -> void:
	visible = false
	get_tree().paused = false
