extends CanvasLayer

signal lock_pressed()
signal open_pressed()

func open() -> void:
	open_pressed.emit()

func lock() -> void:
	lock_pressed.emit()
