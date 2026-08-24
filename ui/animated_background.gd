extends Control

@onready var background: TextureRect = $Background
@export var object_speed: float = 0.2
@export var background_speed: float = 0.3
@export var tween_trans_type: Tween.TransitionType
@export var tween_ease_type: Tween.EaseType

var center: Vector2
var tween: Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	center = Vector2(get_viewport_rect().size/2)

func _process(delta: float) -> void:
	tween = create_tween().set_trans(tween_trans_type).set_ease(tween_ease_type)
	var offset = (center - get_global_mouse_position()) * 0.1
	tween.tween_property(background, "position", offset, background_speed)

