extends Node

signal train_state_changed(state)
signal door_access_changed(is_accesible: bool)
signal npc_invited()
signal npc_raged()
@export var current_train_state: TrainState:
	set(v):
			current_train_state = v
			GameEvents.train_state_changed.emit(v)

enum TrainState {
	Corridor,
	Compartment,
	Peeping
}
