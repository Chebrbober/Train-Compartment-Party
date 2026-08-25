class_name Interactable extends Area2D

enum Type {
	DOOR,
	FOOD,
	BED
}
@export var interact_type = Type.DOOR

signal player_entered(interactable)
signal player_exited(interactable)

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	InteractManager.register_interactable(self)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") or body is CharacterBody2D:
		player_entered.emit(self)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player") or body is CharacterBody2D:
		player_exited.emit(self)
