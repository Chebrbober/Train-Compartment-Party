extends Node

signal train_state_changed(state)
signal door_access_changed(is_accesible: bool)

enum TrainState {
	Corridor,
	Compartment,
	Peeping
}
