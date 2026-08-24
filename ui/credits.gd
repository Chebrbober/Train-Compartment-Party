extends PanelContainer

@onready var main_buttons: PanelContainer = %MainButtons
@onready var color_rect: ColorRect = %ColorRect

func _ready() -> void:
	visible = false

func appear() -> void:
	visible = true
	color_rect.visible = true
	main_buttons.visible = false


func _on_back_pressed() -> void:
	visible = false
	color_rect.visible = false
	main_buttons.visible = true