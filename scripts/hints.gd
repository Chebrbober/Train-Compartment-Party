extends CanvasLayer

@export var tween_duration: float = 1.0
@export var display_duration: float = 3.0
@export var knock_hint_text: String = "Go check the door (stairs)"
@export var day_phase_changed_hint_text: String = "You can go sleep now even if you don't have NPC"
@onready var label: Label = $Label
var tween: Tween

func _ready() -> void:
	GameEvents.npc_arrived.connect(knock_hint)
	GameEvents.day_phase_changed.connect(day_phase_changed_hint)

func animate() -> void:
	if tween:
		tween.kill()

	label.self_modulate.a = 0.0

	var tween = create_tween()
	tween.tween_property(label, "self_modulate:a", 1.0, tween_duration)
	tween.tween_interval(display_duration)
	tween.tween_property(label, "self_modulate:a", 0.0, tween_duration)

func knock_hint() -> void:
	animate()
	label.text = knock_hint_text

func day_phase_changed_hint(phase: GameEvents.DayPhase) -> void:
	if phase == GameEvents.DayPhase.Bedtime:
		animate()
		label.text = day_phase_changed_hint_text
