extends Node

@export var npc_node: Node2D
@onready var timer: Timer = $Timer

func _on_timer_timeout() -> void:
	print('timeout')
	if GameEvents.current_train_state == GameEvents.TrainState.Compartment:
		appear()
		print('call appear npc func')

func appear() -> void:
	npc_node.update()
	npc_node.visible = true
	GameEvents.door_access_changed.emit(true)
	print("npc appeared")

func anger() -> void:
	print("anger animation")
	npc_node.animation_player.play("anger")
	await npc_node.animation_player.animation_finished
	GameEvents.npc_raged.emit()

func invite() -> void:
	print("invite animation")
	npc_node.animation_player.play("happiness")
	await npc_node.animation_player.animation_finished
	GameEvents.npc_invited.emit()

func reset_timer() -> void:
	timer.start(randf_range(10,20))
	GameEvents.door_access_changed.emit(false)
	print('timer has been reset')
