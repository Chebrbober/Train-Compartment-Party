extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	visible = false

func play() -> void:
	var screen_size = get_viewport().get_visible_rect().size
	sprite.position = screen_size / 2.0

	animation_player.play("jump")
	visible = true
