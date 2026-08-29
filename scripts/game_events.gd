extends Node

signal train_state_changed(state)
signal door_access_changed(is_accesible: bool)
signal peephole_opened()
signal npc_invited()
signal npc_raged()
signal npc_arrived()
signal day_phase_changed(phase: DayPhase)
signal day_count_changed()
signal game_over(win: bool)

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

var current_day: int = 1:
	set(v):
		current_day = v
		day_count_changed.emit()

		if v == 8:
			game_over.emit(true)
var current_phase: DayPhase = DayPhase.Day:
	set(v):
		current_phase = v
		day_phase_changed.emit(v)
		door_access_changed.emit(false)
var has_sleeping_npc: bool = false
var has_bad_npc: bool = false

func reset_game() -> void:
	current_train_state = TrainState.Corridor
	current_phase = DayPhase.Day
	current_day = 1
	has_sleeping_npc = false

func next_day() -> void:
	has_sleeping_npc = false
	current_phase = DayPhase.Day
	current_day += 1
	door_access_changed.emit(false)
	print("Day ", current_day)
