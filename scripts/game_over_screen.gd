extends CanvasLayer

@export_file("*.tscn") var menu_scene: String
@export var win_text: String = "[b][rainbow freq=1.0 sat=0.8 val=0.8]GAME OVER[/rainbow][/b]"
@export var loose_text: String = "[b][color=red]GAME OVER[/color][/b]"
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var title: RichTextLabel = $VBoxContainer/Title

func _ready() -> void:
	visible = false
	GameEvents.game_over.connect(_on_game_over)

func _on_game_over(win: bool) -> void:
	visible = true
	animation_player.play("appear")
	if win:
		title.text = win_text
	else:
		title.text = loose_text



func _on_menu_pressed() -> void:
	TransitionScene.transition_to(menu_scene)

func _on_retry_pressed() -> void:
	TransitionScene.transition_to("", func() -> void:
		get_tree().reload_current_scene()
	)
