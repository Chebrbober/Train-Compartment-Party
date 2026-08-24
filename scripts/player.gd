extends CharacterBody2D

@export var speed: float = 100
@onready var body: CanvasGroup = $Body
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _physics_process(delta: float) -> void:
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
