extends Node

@export var interact_button: AnimatedSprite2D
@export var button_y_offset: float = 25
@export var tween_duration: float = 0.25
var current_interactable
var tween: Tween

signal pressed(interactable: Interactable)

func _ready() -> void:
	interact_button.self_modulate = Color8(255,255,255,0)

func register_interactable(interactable: Node) -> void:
	if not interactable.player_entered.is_connected(_on_interactable_entered):
		interactable.player_entered.connect(_on_interactable_entered)
	if not interactable.player_exited.is_connected(_on_interactable_exited):
		interactable.player_exited.connect(_on_interactable_exited)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		press()

func _on_interactable_entered(interactable):
	print('entered')
	current_interactable = interactable
	appear(current_interactable.global_position)

func _on_interactable_exited(_interactable):
	print('exited')
	current_interactable = null
	disappear()

func appear(pos: Vector2) -> void:
	if tween:
		tween.kill()

	tween = create_tween()
	interact_button.global_position = Vector2(pos.x, pos.y - button_y_offset)
	tween.tween_property(interact_button, "self_modulate", Color8(255,255,255,255), tween_duration).from_current()

func press() -> void:
	interact_button.play("pressed")
	pressed.emit(current_interactable)
	current_interactable = null

func disappear() -> void:
	if tween:
		tween.kill()

	tween = create_tween()
	tween.tween_property(interact_button, "self_modulate", Color8(255,255,255,0), tween_duration).from_current()
	current_interactable = null
