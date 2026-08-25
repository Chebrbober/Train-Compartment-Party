class_name Interactable extends Area2D

signal player_entered(interactable)
signal player_exited(interactable)

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	InteractManager.register_interactable(self)

func _on_body_entered(body: Node2D) -> void:
	print("body entered ", body.name)
	if body.is_in_group("player") or body is CharacterBody2D:
		print('that was player')
		player_entered.emit(self)

func _on_body_exited(body: Node2D) -> void:
	print("body exited", body.name)
	if body.is_in_group("player") or body is CharacterBody2D:
		print('that was player')
		player_exited.emit(self)
