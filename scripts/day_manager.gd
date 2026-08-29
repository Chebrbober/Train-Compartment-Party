extends Node

@onready var day_timer: Timer = $DayTimer
@onready var bedtime_timer: Timer = $BedtimeTimer
@onready var timer_label: Label = $TimerHUD/HBoxContainer/TimerLabel
@onready var day_label: Label = $TimerHUD/HBoxContainer/DayLabel
@onready var canvas_modulate: CanvasModulate = $CanvasModulate
@onready var day_wait_time = day_timer.wait_time
@onready var bedtime_wait_time = bedtime_timer.wait_time

func _ready() -> void:
	GameEvents.train_state_changed.connect(start_day_timer)
	GameEvents.day_phase_changed.connect(_on_day_phase_changed)
	GameEvents.day_count_changed.connect(_on_day_count_changed)
	start_day_timer(GameEvents.current_train_state)

func start_day_timer(state: GameEvents.TrainState) -> void:
	if state == GameEvents.TrainState.Compartment and day_timer.is_stopped():
		day_timer.start(day_wait_time)
		print('Day timer started for day ', GameEvents.current_day)

func _process(delta: float) -> void:
	if !bedtime_timer.is_stopped():
		update_timer(bedtime_timer.time_left)
	else:
		update_timer(day_timer.time_left)

func update_timer(time: float = NAN):
	if is_nan(time):
		timer_label.text = "0:00"
		return

	var minutes = int(time) / 60
	var seconds = int(time) % 60
	timer_label.text = "%d:%02d" % [minutes, seconds]

func _on_day_timeout() -> void:
	print("Day ended. Entering 1-minute bedtime prep window.")
	GameEvents.current_phase = GameEvents.DayPhase.Bedtime
	bedtime_timer.start(bedtime_wait_time)

func _on_bedtime_timeout() -> void:
	print("Night has already began...")
	GameEvents.current_phase = GameEvents.DayPhase.Night

func _on_day_phase_changed(phase: GameEvents.DayPhase) -> void:
	if phase == GameEvents.DayPhase.Night:
		timer_label.visible = false
		canvas_modulate.visible = true
	if phase == GameEvents.DayPhase.Day:
		timer_label.visible = true
		canvas_modulate.visible = false

func _on_day_count_changed() -> void:
	day_timer.stop()
	bedtime_timer.stop()
	day_timer.start(day_wait_time)
	bedtime_timer.wait_time = bedtime_wait_time
	day_label.text = "Day %d" % GameEvents.current_day
