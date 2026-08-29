extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func appear_and_kill() -> void:
	visible = true
	animation_player.play("kill")

func emit_player_killed() -> void:
	GameEvents.game_over.emit(false)
