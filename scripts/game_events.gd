extends Node

signal train_state_changed(state)

enum TrainState {
	Corridor,
	Compartment,
	Peeping
}
