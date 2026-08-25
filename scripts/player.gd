extends CharacterBody2D

@export var speed: float = 100
@onready var body: CanvasGroup = $Body
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var move_on_y_axis: bool = false

func _physics_process(delta: float) -> void:
	if not is_on_floor() and !move_on_y_axis:
		velocity.y += gravity * delta

	var direction_x := Input.get_axis("move_left", "move_right")
	var direction_y := Input.get_axis("move_up", "move_down")

	if direction_x or (move_on_y_axis and direction_y != 0):
		velocity.x = direction_x * speed
		animation_player.play("walking")
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		animation_player.play("idle")

	if move_on_y_axis:
		if direction_y:
			velocity.y = direction_y * speed
		else:
			velocity.y = move_toward(velocity.y, 0, speed)

	if direction_x > 0 :
		body.scale.x = 1
	elif direction_x < 0:
		body.scale.x = -1

	move_and_slide()
