extends Node

@export var npc_node: Node2D
@onready var timer: Timer = $Timer

func _ready() -> void:
	GameEvents.day_count_changed.connect(reset_timer)

func _on_timer_timeout() -> void:
	print('timeout')
	if GameEvents.current_train_state == GameEvents.TrainState.Compartment:
		appear()
		print('NPC appeared at the door')

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
	if GameEvents.current_train_state != GameEvents.TrainState.Corridor:
		if !GameEvents.has_sleeping_npc:
			var random_time = randf_range(15, 25)
			timer.start(random_time)
			GameEvents.door_access_changed.emit(false)
			print('Timer has been reset. Next guest in: ', random_time)
		else:
			timer.stop()
			GameEvents.door_access_changed.emit(false)
			print("Player found a npc to sleep with")
