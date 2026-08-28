extends CanvasLayer

@onready var buttons: VBoxContainer = $Buttons

signal lock_pressed()
signal open_pressed()

func appear() -> void:
	buttons.visible = true

func open() -> void:
	open_pressed.emit()
	buttons.visible = false

func lock() -> void:
	lock_pressed.emit()
	buttons.visible = false
