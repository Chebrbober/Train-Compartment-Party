extends CanvasLayer

@onready var buttons: VBoxContainer = $Buttons
@onready var random_screamer: CanvasLayer = $RandomScreamer

signal lock_pressed()
signal open_pressed()
signal appeared()

func _ready() -> void:
	appeared.connect(_on_appeared)

func appear() -> void:
	visible = true
	buttons.visible = true
	appeared.emit()

func open() -> void:
	open_pressed.emit()
	buttons.visible = false

func lock() -> void:
	lock_pressed.emit()
	buttons.visible = false

func _on_appeared() -> void:
	if randf() < 0.5:
		random_screamer.play()
		print("povezlo")
	else:
		print("ne povezlo")
