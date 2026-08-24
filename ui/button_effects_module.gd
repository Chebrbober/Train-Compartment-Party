class_name AnimatedButton extends Button

@export var ease_type: Tween.EaseType = Tween.EaseType.EASE_OUT
@export var trans_type: Tween.TransitionType = Tween.TransitionType.TRANS_CUBIC
@export var anim_duration: float = 0.2
@export var scale_amount: Vector2 = Vector2(1.15, 1.15)

var tween: Tween = null

func _ready() -> void:
	button_down.connect(_on_button_down)
	button_up.connect(_on_button_up)
	mouse_entered.connect(_on_mouse_hovered.bind(true))
	mouse_exited.connect(_on_mouse_hovered.bind(false))
	pivot_offset_ratio = Vector2(0.5, 0.5)

func reset_tween() -> void:
	if tween:
		tween.kill()
	tween = create_tween().set_ease(ease_type).set_trans(trans_type).set_parallel(true)

func _on_mouse_hovered(hovered: bool) -> void:
	reset_tween()
	tween.tween_property(self, "scale", scale_amount if hovered else Vector2.ONE, anim_duration)

func _on_button_down():
	reset_tween()
	tween.tween_property(self, "scale", Vector2(0.9, 0.9), 0.05)

func _on_button_up():
	reset_tween()	
	tween.tween_property(self, "scale", Vector2(1,1), 0.25)
