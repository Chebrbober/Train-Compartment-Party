extends Node

signal train_state_changed(state)
signal door_access_changed(is_accesible: bool)
signal peephole_opened()
signal npc_invited()
signal npc_raged()
signal day_phase_changed(phase)

@export var current_train_state: TrainState:
	set(v):
			current_train_state = v
			GameEvents.train_state_changed.emit(v)

enum TrainState {
	Corridor, Compartment, Peeping
}
enum DayPhase {
	Day, Bedtime, Night
}

var current_day: int = 1
var current_phase: DayPhase = DayPhase.Day
var has_sleeping_npc: bool = false

func reset_game() -> void:
	current_train_state = TrainState.Corridor
	current_phase = DayPhase.Day
	has_sleeping_npc = false
