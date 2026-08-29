extends CanvasLayer

func _ready() -> void:
	visible = true

func _on_back_pressed() -> void:
	visible = false
