class_name TransitionManager extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	visible = false

func transition_to(path_to_scene: String) -> void:
	animation_player.play("trans")
	var timer = get_tree().create_timer(0.9)
	await timer.timeout

	get_tree().change_scene_to_file(path_to_scene)
	get_parent().process_mode = Node.PROCESS_MODE_DISABLED
	
func toggle_pause(to_resume: bool) -> void:
	if to_resume:
		get_tree().paused = false
		get_parent().process_mode = Node.PROCESS_MODE_ALWAYS
	else:
		get_parent().process_mode = Node.PROCESS_MODE_DISABLED
		get_tree().paused = true
