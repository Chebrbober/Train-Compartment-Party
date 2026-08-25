extends CharacterBody2D

@export var speed: float = 100
@onready var body: CanvasGroup = $Body
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var move_on_y_axis: bool = false

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * speed
		animation_player.play("walking")
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		animation_player.play("idle")

	if direction > 0:
		body.scale.x = 1
	elif direction < 0:
		body.scale.x = -1

	move_and_slide()
